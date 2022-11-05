NB. =========================================================
NB. Reading and writing IPC
NB. =========================================================

NB. Tables are columnar store in 'arrays', each of which is a column. 
NB.   Tables are are not a common format and are not serializable.
NB.   Arrays can be batched into chunked arrawys, which may vary in length between columns.
NB. IPC format files and streaming data are stored in rows.
NB.   Batches of rows are called 'recordBatches', suitable for storing and streaming.
NB.   IPC is a common format and is serializable.
NB.   '.arrow' and '.feather' files are IPC format files with headers and footers, suitable for random access.
NB.   '.arrows' files are streaming IPC format without footers.

NB. https://arrow.apache.org/docs/cpp/tables.html#record-batches
NB. Table: Logical table as sequence of chunked arrays.
NB. RecordBatch: Collection of equal-length arrays matching a particular Schema.
NB. A record batch is table-like data structure that is semantically a sequence of fields, each a contiguous Arrow array

NB. ".arrow"  We recommend the “.arrow” extension for files created with this format. Note that files created with this format are sometimes called “Feather V2” or with the “.feather” extension, the name and the extension derived from “Feather (V1)”, which was a proof of concept early in the Arrow project for language-agnostic fast data frame storage for Python (pandas) and R.
NB. ".arrows" We recommend the “.arrows” file extension for the streaming format although in many cases these streams will not ever be stored as files.
NB. https://arrow.apache.org/docs/format/Columnar.html

NB. IPC Format
NB. The columnar IPC protocol utilizes a one-way stream of binary messages of these types:
NB. 1) Schema 2) RecordBatch 3) DictionaryBatch
NB. The message encapsulation format in flatbuffers
NB. https://arrow.apache.org/docs/format/Columnar.html#encapsulated-message-format


NB. Tbere are two concepts of streams in Arrow; the term is overloaded and this is a a source of confusion.
NB. 1) Input and output streams, which reference interfaces to data stores.
NB. 2) The writers for IPC-format files without footers, suitable for streaming.
	NB. The difference between RecordBatchFileReader and RecordBatchStreaader 
	NB. is that the input source must have a seek method for random access. 


NB. Goal to formalize:
NB. arrow::read_ipc_stream()
NB. arrow::read_feather()
NB. arrow::read_parquet()
NB. arrow::read_csv_arrow()
NB. arrow::read_json_arrow()
NB. arrow::read_delim_arrow()
NB. arrow::read_schema()
NB. arrow::read_message()
NB. arrow::read_tsv_arrow()

NB. Event-driven API
NB. https://arrow.apache.org/docs/cpp/api/ipc.html#event-driven-api
NB. listener StreamDecoder


NB. =========================================================

newList =. {{
listitems =.y
listPtr =. <0
for_listitem.  listitems do. 
listPtr =. ptr g_list_append listPtr;<listitem
end. 
listPtr
}}

setBytes =. {{
bytePtr =. mema ] byteCount =. # y
y memw bytePtr,0,byteCount,2
gBtyesPtr =. ptr g_bytes_new_static (<bytePtr);byteCount
gBtyesPtr
}}

newSchema=: {{
NB. 'name dataType nullableBoolean'
fields =. y
fieldPtrs =. newField"1 fields
listPtr =. newList fieldPtrs
schemaPtr =. ptr garrow_schema_new <listPtr
schemaPtr
}}

makeReadOptions=: {{
readoptions =. y
readOptionsPtr =. garrow
NB. "max-recursion-depth"	gint
NB. "use-threads"	gboolean
readOptionsPtr =. ptr garrow_read_options_new ''
NB. setProperties
readOptionsPtr
}}

makeWriteOptions=: {{
readoptions =. y
NB. "use-threads"	gboolean
NB. "alignment"	gint
NB. "allow-64bit" 	gboolean
NB. "codec"		GArrowCodec *
NB. "max-recursion-depth"	gint
NB. "use-threads"	gboolean
NB. "write-legacy-ipc-format"	gboolean
writeOptionsPtr =. ptr garrow_write_options_new ''
NB. setProperties
writeOptionsPtr
}}


NB. =========================================================
NB. Input streams
NB. =========================================================

fileInputStream =. {{
filepath =. y
filePtr =. setString  jpath filepath
e=. < mema 4
inputStreamPtr =. ptr garrow_file_input_stream_new filePtr;<e
garrow_input_stream_align inputStreamPtr;64;<e
memf > e
inputStreamPtr
}}

bufferInputStream =. {{
gBtyesPtr =. y
bufferPtr =. ptr garrow_buffer_new_bytes <gBtyesPtr
bufferInputStreamPtr =. ptr garrow_buffer_input_stream_new <bufferPtr 
e=. < mema 4
garrow_input_stream_align bufferInputStreamPtr;64;<e
ret g_object_unref <  bufferPtr
memf > e
bufferInputStreamPtr
}}


memmoryMappedFileInputStream =. {{
filepath =. y
filePtr =. setString  jpath filepath
e=. < mema 4
inputStreamPtr =. ptr garrow_memory_mapped_input_stream_new filePtr;<e
garrow_input_stream_align inputStreamPtr;64;<e
memf > e
inputStreamPtr
}}

gioInputStream =. {{
inputStream =. y
inputStreamPtr =. ptr garrow_gio_input_stream_new inputStream
e=. < mema 4
garrow_input_stream_align inputStreamPtr;64;<e
memf > e
inputStreamPtr
}}

codec =. {{
compressionTypes =. 'UNCOMPRESSED SNAPPY GZIP BROTLI ZSTD LZ4 LZO BZ2'
NB. UNCOMPRESSED Not compressed.
NB. SNAPPY Snappy compression.
NB. GZIP gzip compression.
NB. BROTLI Brotli compression.
NB. ZSTD Zstandard compression.
NB. LZ4 LZ4 compression.
NB. LZO LZO compression.
NB. BZ2 bzip2 compression.
compression =. y 
compressionEnum=. {. (< tolower compression) I.@E. ;: tolower compressionTypes
e=. < mema 4
codecPtr =. ptr garrow_codec_new  compressionEnum;<e
if. -. * > codecPtr do. 
echo 'Invalid compression type. Valid compression types are: ', > ;: 'UNCOMPRESSED SNAPPY GZIP BROTLI ZSTD LZ4 LZO BZ2'
codecPtr  =. <0
else. 
NB. echo ret garrow_codec_get_compression_type  < codecPtr
NB. codecNamePtr =. ptr garrow_codec_get_name < codecPtr
end.
codecPtr 
}}

compressedInputStream =. {{
'codecName inputStreamPtr' =. y
codePtr =. codec codecName
e=. < mema 4
inputStreamPtr =. ptr garrow_compressed_input_stream_new  codecPtr;inputStreamPtr;<e
garrow_input_stream_align inputStreamPtr;64;<e
memf > e
inputStreamPtr
}}



NB. =========================================================
NB. Output streams
NB. =========================================================

newResizableBuffer =: {{
e=. < mema 4
ptr garrow_resizable_buffer_new 1;<e
}}

newBufferOutpuStream =:{{
ptr garrow_buffer_output_stream_new < newResizableBuffer''
}}

fileOutpuStream=:{{
'filepath appendboolean' =. y
fnPtr =. setString jpath filepath
e=. < mema 4
ptr garrow_file_output_stream_new fnPtr;appendboolean;<e
}}

newCompressedOutpuStream =:{{
'codecPtr outputStreamPtr' =. y
e=. < mema 4
ptr garrow_compressed_output_stream_new codecPtr;outputStreamPtr;<e
}}

recordBatchStreamWriter =:{{
'outputStreamPtr schemaPtr' =.y 
e=. < mema 4
recordBatchStreamWriterPtr =.ptr garrow_record_batch_stream_writer_new outputStreamPtr;schemaPtr;<e
recordBatchStreamWriterPtr
}}

NB. =========================================================
NB. IPC WRITER CLASSES
NB. =========================================================

writeRecordBatchStream =. {{
NB. IPC stream format is  optionally footer-terminated and does not contain ARROW1 magic numbers at beginning and end.
'filepath appendboolean recordBatchPtr' =. y
fileOutputStreamPtr =. fileOutpuStream filepath;appendboolean
NB. e1=. < mema 4
NB. ret garrow_output_stream_align fileOutputStreamPtr;64;<e1
writeOptionsPtr =. makeWriteOptions ''
e2=. < mema 4
schemaPtr =. ptr garrow_record_batch_get_schema <recordBatchPtr
recordBatchStreamWriterPtr =. ptr garrow_record_batch_stream_writer_new fileOutputStreamPtr;schemaPtr;<e2
NB. Then you could do the thing below and then close the writer, or use the garrow_record_batch_writer_write_record_batch on the writer.
e3=. < mema 4
garrow_record_batch_writer_write_record_batch recordBatchStreamWriterPtr;recordBatchPtr;<e3
NB. echo ret garrow_output_stream_write_record_batch fileOutputStreamPtr;recordBatchPtr;writeOptionsPtr;<e3
1
}}

recordBatchFileWriter =:{{
'outputStreamPtr schemaPtr' =.y 
e=. < mema 4
recordbatchFilestreamWriterPtr =.ptr garrow_record_batch_file_writer_new outputStreamPtr;schemaPtr;<e
recordbatchFilestreamWriterPtr
}}


writeRecordBatchFile =. {{
'filepath appendboolean recordBatchPtr' =. y
NB. The IPC file format is footer-terminated and does contain ARROW1 magic numbers at beginning and end.
fileOutputStreamPtr =. fileOutpuStream filepath;appendboolean
e=. < mema 4
ret garrow_output_stream_align fileOutputStreamPtr;64;<e
writeOptionsPtr =. (makeWriteOptions '')
e1=. < mema 4
schemaPtr =. ptr garrow_record_batch_get_schema <recordBatchPtr
NB. recordFileStreamWriterPtr =. ptr garrow_record_batch_file_writer_new fileOutputStreamPtr;schemaPtr;<e1 NB. Doesn't write anything yet.
recordbatchFilestreamWriterPtr =.  recordBatchFileWriter fileOutputStreamPtr;<schemaPtr
NB. Then you could do the thing below and then close the writer, or use the garrow_record_batch_writer_write_record_batch on the writer.
e3=. < mema 4
garrow_record_batch_writer_write_record_batch recordbatchFilestreamWriterPtr;recordBatchPtr;<e3
NB. echo ret garrow_output_stream_write_record_batch fileOutputStreamPtr;recordBatchPtr;writeOptionsPtr;<e3
NB. Close writes the terminating footer.
e4=. < mema 4
success =. ret garrow_record_batch_writer_close recordbatchFilestreamWriterPtr;< e4
success
}}

writeTableFile =: {{
'filepath appendboolean tablePtr' =. y
schemaPtr =. getSchemaPt tablePtr
recordBatchFileWriterPtr =.  recordBatchFileWriter (fileOutpuStream filepath;appendboolean);<schemaPtr
e1=. < mema 4
success1 =. ret garrow_record_batch_writer_write_table recordBatchFileWriterPtr;tablePtr;<e1
e2=. < mema 4
success2 =. ret garrow_record_batch_writer_close recordBatchFileWriterPtr;<e2
memf > e1
memf > e2
>./ success1, success2 
}}


writeTensorFile =. {{
'filepath appendboolean tensorPtr' =. y
fileOutputStreamPtr =. fileOutpuStream filepath;appendboolean
e=. < mema 4
ret garrow_output_stream_write_tensor outputStreamPtr;tensorPtr;<e
}}


NB. =========================================================
NB. IPC READER CLASSES
NB. =========================================================

recordBatchFileReader =. {{
filepath =. y
fileInputStreamPtr =. fileInputStream filepath
e0=. < mema 4
ret garrow_input_stream_align fileInputStreamPtr;64;<e0
e1=. < mema 4
NB. echo '[+] Size: ', ": ret garrow_seekable_input_stream_get_size fileInputStreamPtr;<e1
e2=. < mema 4
rbreaderPtr =. ptr garrow_record_batch_file_reader_new fileInputStreamPtr;<e2
'Not a valid recordbatchReader.' assert * >  rbreaderPtr
NB. schemaPtr =. ptr garrow_record_batch_file_reader_get_schema <rbreaderPtr
NB. echo '[+] Schema: '
NB. echo getSchemaFields schemaPtr
recordBatchCount =. ret garrow_record_batch_file_reader_get_n_record_batches <rbreaderPtr
NB. echo '[+] Recordbatch count: ', ":ret garrow_record_batch_file_reader_get_n_record_batches <rbreaderPtr
NB. e3=. < mema 4
NB. p3r garrow_input_stream_read_record_batch fileInputStreamPtr;schemaPtr;(makeReadOptions'');<e2
e4=. < mema 4
recordBatchPtr =. (ptr@garrow_record_batch_file_reader_read_record_batch)"1 rbreaderPtr ;"0 1 (i. recordBatchCount);"0 0<e4
('Not a valid recordbatch.'&assert)@* each recordBatchPtr
recordBatchPtr
}}

recordBatchStreamReader =: {{
filepath =. y
fileInputStreamPtr =. fileInputStream filepath
'Not a vaild inputstream pointer.' assert * > fileInputStreamPtr
e1=. < mema 4
ret garrow_input_stream_align fileInputStreamPtr;64;<e1
NB. echo ret garrow_seekable_input_stream_get_size fileInputStreamPtr;<e
e2=. < mema 4
streamReaderPtr =. ptr garrow_record_batch_stream_reader_new fileInputStreamPtr;<e2
'Not a valid streamReader.' assert * >  streamReaderPtr
schemaPtr =. ptr garrow_record_batch_reader_get_schema <streamReaderPtr
NB. echo getSchemaFields schemaPtr
readOptionsPtr =. makeReadOptions''
'Not a valid table.' assert * > schemaPtr
e4=. < mema 4
recordBatchPtr =. ptr garrow_input_stream_read_record_batch fileInputStreamPtr;schemaPtr;readOptionsPtr;<e4
NB. getString ptr garrow_record_batch_to_string recordBatchPtr;<e
recordBatchPtr
}}


fileInputStreamTable =: {{
NB. read input stream directly from file.
filepath =. y
inputStreamPtr =. fileInputStream filepath
e =. < mema 4
streamReaderPtr =. ptr garrow_record_batch_stream_reader_new inputStreamPtr;<e
tablePtr =. ptr garrow_record_batch_reader_read_all streamReaderPtr;<e
memf > e
ret  g_object_unref < inputStreamPtr
ret  g_object_unref < streamReaderPtr
tablePtr
}}

byteInputStreamTable =.{{
bytes =. y
bufferInputStreamPtr =. bufferInputStream ] gBtyesPtr =. setBytes bytes
e =. < mema 4
streamReaderPtr =. ptr garrow_record_batch_stream_reader_new bufferInputStreamPtr;<e
tablePtr =. ptr garrow_record_batch_reader_read_all streamReaderPtr;<e
memf > e
bufferPtr =. ptr garrow_buffer_input_stream_get_buffer < bufferInputStreamPtr
ret g_object_unref < bufferPtr
ret g_object_unref < streamReaderPtr
ret g_object_unref < bufferInputStreamPtr
bytePtr =. ptr g_bytes_get_data  gBtyesPtr;<<0
g_bytes_unref < gBtyesPtr
memf  > bytePtr 
tablePtr
}}


recordBatchTable =:{{
recordBatches =. y
schemaPtr =. ptr garrow_record_batch_get_schema < {. recordBatches
recordBatchArrayPointer  =. setInts > recordBatches
countRecordBatches =. # recordBatches
e=. < mema 4
tablePtr =. ptr garrow_table_new_record_batches schemaPtr;recordBatchArrayPointer;countRecordBatches;<e
memf > e
tablePtr
}}





NB. =========================================================
NB. Test writing with several methods:
NB. =========================================================

load jpath '~JPackageDev/jarrow/src/wip/flight.ijs'

clientPtr =. createClient@connectLocation 'grpc+tcp://localhost:5005'
flightInfoPtrs =. getClientFlightInfo clientPtr; ''   NB. This could be filtered with search criteria.
flightInfo flightInfoPtrs
endpointPtrs =. <@getEndpoints flightInfoPtrs

NB. Select  first info and first endpoint for that info.
endpointPtr =. 0 { 0{:: endpointPtrs

NB. Get table pointers:
tblPtr1 =. flightStreamReadAllTable endPointsFlightstreamReader clientPtr;<endpointPtr

NB. Get recordbatch  pointers:
recordBatchPtrs =. flightStreamRecordBatch endPointsFlightstreamReader clientPtr;<endpointPtr

NB. Write into an arrow file
NB. Write with: garrow_record_batch_writer_write_table
arrowFP =. '~/Downloads/example_table.arrow'
writeTableFile  arrowFP;0;< tblPtr1

NB. Write into an arrow file
NB. Write with: garrow_record_batch_writer_write_record_batch
arrowFP =. '~/Downloads/example_recordbatch.arrow'
writeRecordBatchFile arrowFP;0;(<  {.recordBatchPtrs) NB. Only writes the first recordbatch for now.

NB. Write into an arrows stream
NB. This should iterate over a list of recordbatches rather than a single recordbatch
NB. Write with: garrow_output_stream_write_record_batch
arrowFP =. '~/Downloads/example.arrows'
writeRecordBatchStream arrowFP;0;(< {.recordBatchPtrs) NB. Only writes the first recordbatch for now.


NB. =========================================================
NB. File IPC to recordbatch to table test

arrowFP =. '~/Downloads/example_recordbatch.arrow' NB. works, created with garrow_record_batch_writer_write_record_batch
readsTable recordBatchTable recordBatchFileReader arrowFP

arrowFP =. '~/Downloads/example_table.arrow' NB. works, created with garrow_record_batch_writer_write_table
readsTable recordBatchTable recordBatchFileReader arrowFP


NB. Stream IPC to table tests
y =. '~/Downloads/flights-200k.arrows'
g_object_unref < fileInputStreamTable y
g_object_unref < byteInputStreamTable (fread jpath y)
(1e3) 6!:2  'g_object_unref < fileInputStreamTable y'
(1e3) 6!:2  'g_object_unref < byteInputStreamTable (fread jpath y)'

y =. '~/Downloads/scrabble_games.arrows'
g_object_unref < fileInputStreamTable y
g_object_unref < byteInputStreamTable (fread jpath y)
(1e3) 6!:2  'g_object_unref < fileInputStreamTable y'
(1e3) 6!:2  'g_object_unref < byteInputStreamTable (fread jpath y)'

y =. '~/Downloads/example.arrows' 
g_object_unref < fileInputStreamTable y
g_object_unref < byteInputStreamTable (fread jpath y)
(1e3) 6!:2  'g_object_unref < fileInputStreamTable y'
(1e3) 6!:2  'g_object_unref < byteInputStreamTable (fread jpath y)'

readsTable tp =. byteInputStreamTable (fread jpath y)
ret g_object_unref < tp


NB. * * u * * g_input_stream_read_bytes (GInputStream *stream,gsize count,GCancellable *cancellable, GError **error);GBytes *
NB. * * g_input_stream_clear_pending (GInputStream *stream);void




