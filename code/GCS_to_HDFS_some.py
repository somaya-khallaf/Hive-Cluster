import os, tempfile
import pyarrow.parquet as pq, pyarrow.orc as orc, pyarrow as pa
from google.cloud import storage
from hdfs import InsecureClient

# Configuration
CREDENTIALS = "/code/analyticalsql-bb2a6b71ad5b.json"
GCS_BUCKET = "airline_dwh"
GCS_PATH = "all_tables/"
HDFS_URL = "http://master1:9870"
HDFS_USER = "hadoop"
HDFS_PATH = "/user/hive/warehouse/airline_dwh_staging.db/"

TABLES = [
    "dim_FareBase", "dim_channel", "dim_promotion", "dim_AirCraft",
    "dim_AirPort", "dim_passenger_profile_history", "dim_Passenger_Profile",
    "dim_date", "dim_country_specific_date", "dim_Passenger", "fact_reservation"
]

def transfer_table(gcs, hdfs, table):
    try:
        blobs = gcs.bucket(GCS_BUCKET).list_blobs(prefix=f"{GCS_PATH}{table}/")
        hdfs.makedirs(f"{HDFS_PATH}{table}/")
        
        for blob in blobs:
            if not blob.name.endswith(".parquet"):
                continue
                
            with tempfile.NamedTemporaryFile(suffix=".parquet") as tmp_pq:
                blob.download_to_filename(tmp_pq.name)
                table_data = pq.read_table(tmp_pq.name)
                
                # Convert timestamp columns to strings
                cols = [col.cast(pa.string()) if str(col.type).startswith("timestamp") else col 
                       for col in table_data.columns]
                table_data = pa.table(cols, names=table_data.schema.names)
                
                orc_path = f"{HDFS_PATH}{table}/{os.path.basename(blob.name).replace('.parquet','.orc')}"
                with tempfile.NamedTemporaryFile(suffix=".orc") as tmp_orc:
                    orc.write_table(table_data, tmp_orc.name)
                    hdfs.upload(orc_path, tmp_orc.name)
        
        print(f"Transferred {table}")
        return True
    except Exception as e:
        print(f"Error transferring {table}: {e}")
        return False

def main():
    os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = CREDENTIALS
    gcs = storage.Client()
    hdfs = InsecureClient(HDFS_URL, user=HDFS_USER)
    
    success = sum(transfer_table(gcs, hdfs, table) for table in TABLES)
    print(f"Done. {success}/{len(TABLES)} tables transferred")

if __name__ == "__main__":
    main()