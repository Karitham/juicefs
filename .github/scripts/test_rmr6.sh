umount /tmp/sync-test
mc rb myminio/test-bucket --force
redis-cli flushall
export JFS_RSA_PASSPHRASE=12345678
set -e

./juicefs-1.0.0 format redis://localhost/1 test-volume --block-size 225 --compress lz4 --shards 1 --storage minio --capacity 1 --inodes 1050368 --trash-days 7421 --encrypt-rsa-key my-priv-key.pem --bucket http://localhost:9000/test-bucket --access-key minioadmin --secret-key minioadmin --debug
./juicefs-1.0.0 mount -d redis://localhost/1 /tmp/sync-test/ --log ~/.juicefs/juicefs.log -o writeback_cache,debug,allow_other --attr-cache 8 --entry-cache 1 --dir-entry-cache 7 --get-timeout 47 --put-timeout 48 --io-retries 8 --max-uploads 76 --max-deletes 58 --buffer-size 438 --upload-limit 754 --download-limit 410 --prefetch 50 --upload-delay 0 --cache-dir ~/.juicefs/cache2 --cache-size 0 --free-space-ratio 0.49999999999999994 --cache-partial-only --backup-meta 332 --heartbeat 7 --open-cache 60 --metrics 127.0.0.1:9568 --debug
./juicefs-1.0.0 umount /tmp/sync-test/ --debug
./juicefs-1.0.0 mount -d redis://localhost/1 /tmp/sync-test/ --log ~/.juicefs/juicefs.log --attr-cache 8 --entry-cache 2 --dir-entry-cache 2 --get-timeout 59 --put-timeout 31 --io-retries 15 --max-uploads 2 --max-deletes 1 --buffer-size 465 --upload-limit 14 --download-limit 783 --prefetch 1 --upload-delay 0 --cache-dir ~/.juicefs/cache1 --cache-size 1024000 --free-space-ratio 0.49999999999999994 --backup-meta 857 --heartbeat 7 --no-bgjob --open-cache 1 --metrics 127.0.0.1:9567 --debug
./juicefs-1.0.0 fsck redis://localhost/1 --debug
echo abc>/tmp/sync-test//file_to_rmr
./juicefs-1.1.0-dev rmr /tmp/sync-test//file_to_rmr --debug
#./juicefs-1.0.1 rmr /tmp/sync-test//file_to_rmr --debug
