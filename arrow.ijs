NB. init
cocurrent 'parrow'

lib =: >@((3&{.)@(TAB&cut)&.>)@(LF&cut)
ret =: 0&{::
ptr =: <@(0&{::)

setString=:{{
l1 =. >:@# string =. , > y
string memw (] stringPt =. mema l1),0,l1,2
<stringPt
}}

setInts=:{{
l =. (# , y)
(,y) memw (] Pt =. mema l * 2^2+IF64),0,l,4
<Pt
}}

getString=:{{memr (> y),0,_1,2}}
getStringFree =: {{res [ memf y [ res=.memr (y=.>y),0,_1,2}}
getInts=:{{memr (> y),0,x,4}}

libload =: {{
  if.     UNAME-:'Linux' do.
    arrow    =. '/usr/lib/x86_64-linux-gnu/libarrow-glib.so'
    parquet  =. '/usr/lib/x86_64-linux-gnu/libparquet-glib.so'
    flight   =. '/usr/lib/x86_64-linux-gnu/libarrow-flight-glib.so'
    dataset  =. '/usr/lib/x86_64-linux-gnu/libarrow-dataset-glib.so'
  elseif. UNAME-:'Darwin' do.
    arrow    =.  '/usr/local/lib/libarrow-glib.dylib'
    parquet  =.  '/usr/local/lib/libparquet-glib.dylib'
    flight   =. '/usr/local/lib/libarrow-flight-glib.dylib'
    dataset   =. '/usr/local/lib/libarrow-dataset-glib.dylib'
  elseif. UNAME-:'Win' do.
    arrow    =. 'C:/msys64/mingw64/bin/libarrow-glib-1500.dll'
    parquet  =. 'C:/msys64/mingw64/bin/libparquet-glib-1500.dll'
    flight   =. 'C:/msys64/mingw64/bin/libarrow-flight-glib-1500.dll'
    dataset  =. 'C:/msys64/mingw64/bin/libarrow-dataset-glib-1500.dll'
  end.
  binariesinstalled =. fexist@> arrow;parquet;flight
  msg =. 'Need to install or update binaries.',LF,'See: https://arrow.apache.org/install/',LF,'Missing files:',LF,  LF joinstring ( (-. binariesinstalled) # arrow;parquet;flight)
  msg assert <./ binariesinstalled
  'libArrow libParquet libFlight'  =: dquote each arrow;parquet;flight NB. Add double-quotes for cd calls.
  1
}}

cbind =: 4 : 0"1 1
  'type name args' =. y
  v =. (x,' ',name,' ',type)&cd
  (". 'name') =: v
  1
)

init =: {{
  libload''
  r=. 1
  r =. r <. <./ libArrow cbind gLibBindings
  r =. r <. <./ libArrow cbind tableBindings, recordBatchBindings, chunkedArrayBindings
  r =. r <. <./ libArrow cbind basicDatatypeBindings, compositeDataTypeBindings
  r =. r <. <./ libArrow cbind basicArrayBindings, compositeArrayBindings
  r =. r <. <./ libArrow cbind schemaBindings, fieldBindings
  r =. r <. <./ libArrow cbind bufferBindings, codecBindings
  r =. r <. <./ libArrow cbind memoryBindings
  r =. r <. <./ libArrow cbind ipcOptionsBindings,readerBindings,orcFileReaderBindings,writerBindings
  r =. r <. <./ libArrow cbind fileSystemBindings, localFileSystemBindings
  r =. r <. <./ libArrow cbind readableBindings, inputStreamBindings, writeableBindings, writeableFileBindings, outputStreamBindings, fileBindings
  r =. r <. <./ libParquet cbind parquetReaderBindings, parquetWriterBindings
  r =. r <. <./ libFlight cbind commonFlightBindings, clientFlightBindings, serverFlightBindings
  r
}}
NB. =========================================================
NB. Basic Data Type
NB.  https://arrow.apache.org/docs/c_glib/arrow-glib/basic-array-classes.html
NB. =========================================================

basicArrayBindings =: lib 0 : 0
* 	garrow_equal_options_new	(void); GArrowEqualOptions *
i *	garrow_equal_options_is_approx	(GArrowEqualOptions *options); gboolean
* * * *	garrow_array_import	(gpointer c_abi_array, GArrowDataType *data_type, GError **error); GArrowArray *
i * * * *	garrow_array_export	(GArrowArray *array, gpointer *c_abi_array, gpointer *c_abi_schema, GError **error); gboolean
i * *	garrow_array_equal	(GArrowArray *array, GArrowArray *other_array); gboolean
i * * *	garrow_array_equal_options	(GArrowArray *array, GArrowArray *other_array, GArrowEqualOptions *options); gboolean
i * *	garrow_array_equal_approx	(GArrowArray *array, GArrowArray *other_array); gboolean
i * x * x x *	garrow_array_equal_range	(GArrowArray *array, gint64 start_index, GArrowArray *other_array, gint64 other_start_index, gint64 end_index, GArrowEqualOptions *options); gboolean
i * x	garrow_array_is_null	(GArrowArray *array, gint64 i); gboolean
i * x	garrow_array_is_valid	(GArrowArray *array, gint64 i); gboolean
x *	garrow_array_get_length	(GArrowArray *array); gint64
x *	garrow_array_get_offset	(GArrowArray *array); gint64
x *	garrow_array_get_n_nulls	(GArrowArray *array); gint64
* *	garrow_array_get_null_bitmap	(GArrowArray *array); GArrowBuffer *
* *	garrow_array_get_value_data_type	(GArrowArray *array); GArrowDataType *
i *	garrow_array_get_value_type	(GArrowArray *array); GArrowType
* * x x	garrow_array_slice	(GArrowArray *array, gint64 offset, gint64 length); GArrowArray *
*c * *	garrow_array_to_string	(GArrowArray *array, GError **error); gchar *
* * * *	garrow_array_view	(GArrowArray *array, GArrowDataType *return_type, GError **error); GArrowArray *
* * * *	garrow_array_diff_unified	(GArrowArray *array, GArrowArray *other_array); gchar *
* * * *	garrow_array_concatenate	(GArrowArray *array, GList *other_arrays, GError **error); GArrowArray *
* l	garrow_null_array_new	(gint64 length); GArrowNullArray *
* *	garrow_primitive_array_get_data_buffer	(GArrowPrimitiveArray *array); GArrowBuffer *
*c x * * x	garrow_boolean_array_new	(gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowBooleanArray *
i * x	garrow_boolean_array_get_value	(GArrowBooleanArray *array, gint64 i); gboolean
*i * *	garrow_boolean_array_get_values	(GArrowBooleanArray *array, gint64 *length); gboolean *
* x * * x	garrow_int8_array_new	(gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowInt8Array *
*l * x	garrow_int8_array_get_value	(GArrowInt8Array *array, gint64 i); gint8
*l * *x	garrow_int8_array_get_values	(GArrowInt8Array *array, gint64 *length); const gint8 *
* x * * x	garrow_uint8_array_new	(gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowUInt8Array *
l * x	garrow_uint8_array_get_value	(GArrowUInt8Array *array, gint64 i); guint8
*l *i *x	garrow_uint8_array_get_values	(GArrowUInt8Array *array, gint64 *length); const guint8 *
* * * x	garrow_int16_array_new	(gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowInt16Array *
i * x	garrow_int16_array_get_value	(GArrowInt16Array *array, gint64 i); gint16  NB. FIX
* * *	garrow_int16_array_get_values	(GArrowInt16Array *array, gint64 *length); const gint16 *
* x * * x	garrow_uint16_array_new	(gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowUInt16Array *  NB. FIX
i * x	garrow_uint16_array_get_value	(GArrowUInt16Array *array, gint64 i); guint16  NB. FIX
* * *	garrow_uint16_array_get_values	(GArrowUInt16Array *array, gint64 *length); const guint16 *  NB. FIX
i x * * x	garrow_int32_array_new	(gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowInt32Array *
i * x	garrow_int32_array_get_value	(GArrowInt32Array *array, gint64 i); gint32
*i * *x	garrow_int32_array_get_values	(GArrowInt32Array *array, gint64 *length); const gint32 *
* x * * x	garrow_uint32_array_new	(gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowUInt32Array *
i * x	garrow_uint32_array_get_value	(GArrowUInt32Array *array, gint64 i); guint32
*i * *x	garrow_uint32_array_get_values	(GArrowUInt32Array *array, gint64 *length); const guint32 *
*x x * * x	garrow_int64_array_new	(gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowInt64Array *
x * x	garrow_int64_array_get_value	(GArrowInt64Array *array, gint64 i); gint64
*x * *x	garrow_int64_array_get_values	(GArrowInt64Array *array, gint64 *length); const gint64 *
*x x * * x	garrow_uint64_array_new	(gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowUInt64Array *
x * x	garrow_uint64_array_get_value	(GArrowUInt64Array *array, gint64 i); guint64
*x * *x	garrow_uint64_array_get_values	(GArrowUInt64Array *array, gint64 *length); const guint64 *
* x * * x	garrow_float_array_new	(gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowFloatArray *
f * x	garrow_float_array_get_value	(GArrowFloatArray *array, gint64 i); gfloat
*d * *x	garrow_float_array_get_values	(GArrowFloatArray *array, gint64 *length); const gfloat *
* x * * x	garrow_double_array_new	(gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowDoubleArray *
d * x	garrow_double_array_get_value	(GArrowDoubleArray *array, gint64 i); gdouble
*d * *x	garrow_double_array_get_values	(GArrowDoubleArray *array, gint64 *length); const gdouble *
* x * * * x	garrow_base_binary_array_new	(gint64 length, GArrowBuffer *value_offsets, GArrowBuffer *value_data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowArray *
* * x	garrow_base_binary_array_get_value	(GArrowArray *array, gint64 i); GBytes *
* *	garrow_base_binary_array_get_data_buffer	(GArrowArray *array); GArrowBuffer *
* *	garrow_base_binary_array_get_offsets_buffer	(GArrowArray *array); GArrowBuffer *
* x * * * x	garrow_binary_array_new	(gint64 length, GArrowBuffer *value_offsets, GArrowBuffer *value_data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowBinaryArray *
* * x	garrow_binary_array_get_value	(GArrowBinaryArray *array, gint64 i); GBytes *
* *	garrow_binary_array_get_buffer	(GArrowBinaryArray *array); GArrowBuffer *
* *	garrow_binary_array_get_data_buffer	(GArrowBinaryArray *array); GArrowBuffer *
* *	garrow_binary_array_get_offsets_buffer	(GArrowBinaryArray *array); GArrowBuffer *
* x * * * x	garrow_large_binary_array_new	(gint64 length, GArrowBuffer *value_offsets, GArrowBuffer *value_data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowLargeBinaryArray *
* * x	garrow_large_binary_array_get_value	(GArrowLargeBinaryArray *array, gint64 i); GBytes *
* *	garrow_large_binary_array_get_buffer	(GArrowLargeBinaryArray *array); GArrowBuffer *
* *	garrow_large_binary_array_get_data_buffer	(GArrowLargeBinaryArray *array); GArrowBuffer *
* *	garrow_large_binary_array_get_offsets_buffer	(GArrowLargeBinaryArray *array); GArrowBuffer *
*c * x	garrow_base_string_array_get_value	(GArrowArray *array, gint64 i); gchar *
* x * * * x	garrow_string_array_new	(gint64 length, GArrowBuffer *value_offsets, GArrowBuffer *value_data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowStringArray *
*c * x	garrow_string_array_get_string	(GArrowStringArray *array, gint64 i); gchar *
* x * * * x	garrow_large_string_array_new	(gint64 length, GArrowBuffer *value_offsets, GArrowBuffer *value_data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowLargeStringArray *
* * x	garrow_large_string_array_get_string	(GArrowLargeStringArray *array, gint64 i); gchar *
* x * * x	garrow_date32_array_new	(gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowDate32Array *
i * x	garrow_date32_array_get_value	(GArrowDate32Array *array, gint64 i); gint32
*i * *x	garrow_date32_array_get_values	(GArrowDate32Array *array, gint64 *length); const gint32 *
* x * * x	garrow_date64_array_new	(gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowDate64Array *
x * x	garrow_date64_array_get_value	(GArrowDate64Array *array, gint64 i); gint64
*x * *x	garrow_date64_array_get_values	(GArrowDate64Array *array, gint64 *length); const gint64 *
* * x * * x	garrow_timestamp_array_new	(GArrowTimestampDataType *data_type, gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowTimestampArray *
x * x	garrow_timestamp_array_get_value	(GArrowTimestampArray *array, gint64 i); gint64
*x * *x	garrow_timestamp_array_get_values	(GArrowTimestampArray *array, gint64 *length); const gint64 *
*i * x * * x	garrow_time32_array_new	(GArrowTime32DataType *data_type, gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowTime32Array *
i * x	garrow_time32_array_get_value	(GArrowTime32Array *array, gint64 i); gint32
*i * *x	garrow_time32_array_get_values	(GArrowTime32Array *array, gint64 *length); const gint32 *
*x * x * * x	garrow_time64_array_new	(GArrowTime64DataType *data_type, gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowTime64Array *
x *x x	garrow_time64_array_get_value	(GArrowTime64Array *array, gint64 i); gint64
*x * x	garrow_time64_array_get_values	(GArrowTime64Array *array, gint64 *length); const gint64 *
* * x * * x	garrow_fixed_size_binary_array_new	(GArrowFixedSizeBinaryDataType *data_type, gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowFixedSizeBinaryArray *
i *	garrow_fixed_size_binary_array_get_byte_width	(GArrowFixedSizeBinaryArray *array); gint32
* * x	garrow_fixed_size_binary_array_get_value	(GArrowFixedSizeBinaryArray *array, gint64 i); GBytes *
* *	garrow_fixed_size_binary_array_get_values_bytes	(GArrowFixedSizeBinaryArray *array); GBytes *
*c * x	garrow_decimal128_array_format_value	(GArrowDecimal128Array *array, gint64 i); gchar *
* * x	garrow_decimal128_array_get_value	(GArrowDecimal128Array *array, gint64 i); GArrowDecimal128 *
*c * x	garrow_decimal256_array_format_value	(GArrowDecimal256Array *array, gint64 i); gchar *
* * x	garrow_decimal256_array_get_value	(GArrowDecimal256Array *array, gint64 i); GArrowDecimal256 *
*	garrow_data_type_get_type	(void); int
*	garrow_fixed_width_data_type_get_type	(void); *
*	garrow_boolean_data_type_get_type	(void); *
*	garrow_numeric_data_type_get_type	(void); *
*	garrow_integer_data_type_get_type	(void); *
*	garrow_int8_data_type_get_type	(void); *
*	garrow_uint8_data_type_get_type	(void); *
*	garrow_int16_data_type_get_type	(void); *
*	garrow_uint16_data_type_get_type	(void); *
*	garrow_int32_data_type_get_type	(void); *
*	garrow_uint32_data_type_get_type	(void); *
*	garrow_int64_data_type_get_type	(void); *
*	garrow_uint64_data_type_get_type	(void); *
*	garrow_float_data_type_get_type	(void); *
*	garrow_double_data_type_get_type	(void); *
*	garrow_binary_data_type_get_type	(void); *
*	garrow_fixed_size_binary_data_type_get_type	(void); *
*	garrow_large_binary_data_type_get_type	(void); *
*	garrow_string_data_type_get_type	(void); *
*	garrow_large_string_data_type_get_type	(void); *
*	garrow_temporal_data_type_get_type	(void); *
*	garrow_date32_data_type_get_type	(void); *
*	garrow_date64_data_type_get_type	(void); *
*	garrow_timestamp_data_type_get_type	(void); *
*	garrow_time_data_type_get_type	(void); *
*	garrow_time32_data_type_get_type	(void); *
*	garrow_time64_data_type_get_type	(void); *
*	garrow_interval_data_type_get_type	(void); *
*	garrow_decimal_data_type_get_type	(void); *
*	garrow_decimal128_data_type_get_type	(void); *
*	garrow_decimal256_data_type_get_type	(void); *
*	garrow_extension_data_type_get_type	(void); *
)

NB. =========================================================
NB. Composite Array
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/composite-data-type-classes.html
NB. =========================================================

compositeArrayBindings =: lib 0 : 0
* * x * * * x	garrow_base_list_array_new	(GArrowDataType *data_type, gint64 length, GArrowBuffer *value_offsets, GArrowArray *values, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowArray *
* *	garrow_base_list_array_get_value_type	(GArrowArray *array); GArrowDataType *
* * x	garrow_base_list_array_get_value	(GArrowArray *array , gint64 i); GArrowArray *
* *	garrow_base_list_array_get_values	(GArrowArray *array); GArrowArray *
c i x	garrow_base_list_array_get_value_offset	(GArrowArray *array, gint64 i); typename LIST_ARRAY_CLASS::offset_type
c * x	garrow_base_list_array_get_value_length	(GArrowArray *array, gint64 i); typename LIST_ARRAY_CLASS::offset_type
*c * *x	garrow_base_list_array_get_value_offsets	(GArrowArray *array, gint64 *n_offsets); const typename LIST_ARRAY_CLASS::offset_type *
* * x * * * * x	garrow_list_array_new	(GArrowDataType *data_type, gint64 length, GArrowBuffer *value_offsets, GArrowArray *values, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowListArray *
* *	garrow_list_array_get_value_type	(GArrowListArray *array); GArrowDataType *
* * x	garrow_list_array_get_value	(GArrowListArray *array, gint64 i); GArrowArray *
* *	garrow_list_array_get_values	(GArrowListArray *array); GArrowArray *
i * x	garrow_list_array_get_value_offset	(GArrowListArray *array, gint64 i); gint32
i * x	garrow_list_array_get_value_length	(GArrowListArray *array, gint64 i); gint32
*i * x	garrow_list_array_get_value_offsets	(GArrowListArray *array, gint64 *n_offsets); const gint32 *
* * i * * * x	garrow_large_list_array_new	(GArrowDataType *data_type, gint64 length, GArrowBuffer *value_offsets, GArrowArray *values, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowLargeListArray *
* *	garrow_large_list_array_get_value_type	(GArrowLargeListArray *array); GArrowDataType *
* * x	garrow_large_list_array_get_value	(GArrowLargeListArray *array , gint64 i); GArrowArray *
* *	garrow_large_list_array_get_values	(GArrowLargeListArray *array); GArrowArray *
x * x	garrow_large_list_array_get_value_offset	(GArrowLargeListArray *array, gint64 i); gint64
x * x	garrow_large_list_array_get_value_length	(GArrowLargeListArray *array, gint64 i); gint64
*x * *x	garrow_large_list_array_get_value_offsets	(GArrowLargeListArray *array, gint64 *n_offsets); const gint64 *
* * x * * x	garrow_struct_array_new	(GArrowDataType *data_type, gint64 length, GList *fields, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowStructArray *
* *	garrow_struct_array_get_fields_internal	(GArrowStructArray *array); static GPtrArray *
* * i	garrow_struct_array_get_field	(GArrowStructArray *array, gint i); GArrowArray *
* *	garrow_struct_array_get_fields	(GArrowStructArray *array) GList *
* * *	garrow_struct_array_flatten	(GArrowStructArray *array, GError **error); GList *
* * * * * 	garrow_map_array_new	(GArrowArray *offsets, GArrowArray *keys, GArrowArray *items, GError **error); GArrowMapArray *
* *	garrow_map_array_get_keys	(GArrowMapArray *array); GArrowArray *
* *	garrow_map_array_get_items	(GArrowMapArray *array); GArrowArray *
* * i	garrow_union_array_get_field	(GArrowUnionArray *array, gint i); GArrowArray *
* * * *	garrow_sparse_union_array_new	(GArrowInt8Array *type_ids, GList *fields, GError **error); GArrowSparseUnionArray *
* * * * 	garrow_sparse_union_array_new_data_type	(GArrowSparseUnionDataType *data_type, GArrowInt8Array *type_ids, GList *fields, GError **error); GArrowSparseUnionArray *
* * * * *	garrow_dense_union_array_new	(GArrowInt8Array *type_ids, GArrowInt32Array *value_offsets, GList *fields, GError **error); GArrowDenseUnionArray *
* * * * * *	garrow_dense_union_array_new_data_type	(GArrowDenseUnionDataType *data_type, GArrowInt8Array *type_ids, GArrowInt32Array *value_offsets, GList *fields, GError **error); GArrowDenseUnionArray *
* * * * *	garrow_dictionary_array_new	(GArrowDataType *data_type, GArrowArray *indices, GArrowArray *dictionary, GError **error); GArrowDictionaryArray *
* *	garrow_dictionary_array_get_indices	(GArrowDictionaryArray *array); GArrowArray *
* *	garrow_dictionary_array_get_dictionary	(GArrowDictionaryArray *array); GArrowArray *
* *	garrow_dictionary_array_get_dictionary_data_type	(GArrowDictionaryArray *array); GArrowDictionaryDataType *
) 
NB. =========================================================
NB. Array Builder
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/array-builder-classes.html
NB. =========================================================

arrayBuilderBindings =: lib 0 : 0
ADD TYPES
garrow_array_builder_append_value(GArrowArrayBuilder *builder, VALUE value, GError **error, const gchar *context); gboolean
garrow_array_builder_append_values(VALUE *values, gint64 values_length, const gboolean *is_valids, gint64 is_valids_length, GError **error, const gchar *context, APPEND_FUNCTION append_function); gboolean
garrow_array_builder_append_values(GArrowArrayBuilder *builder, VALUE *values, gint64 values_length, const gboolean *is_valids, gint64 is_valids_length, GError **error, const gchar *context); gboolean
garrow_array_builder_append_values(GArrowArrayBuilder *builder, GBytes **values, gint64 values_length, const gboolean *is_valids, gint64 is_valids_length, GError **error, const gchar *context); gboolean
garrow_array_builder_append_values( GArrowArrayBuilder *builder, VALUE *values, gint64 values_length, const gboolean *is_valids, gint64 is_valids_length, GError **error, const gchar *context, GET_VALUE_FUNCTION get_value_function); gboolean
garrow_array_builder_append_values(GArrowArrayBuilder *builder, GBytes *values, const gboolean *is_valids, gint64 is_valids_length, GError **error, const gchar *context); gboolean
garrow_array_builder_finalize(GObject *object); static void
garrow_array_builder_set_property(GObject *object, guint prop_id, const GValue *value, GParamSpec *pspec); static void
garrow_array_builder_get_property(GObject *object, guint prop_id, GValue *value, GParamSpec *pspec); static void
garrow_array_builder_init(GArrowArrayBuilder *builder); static void
garrow_array_builder_class_init(GArrowArrayBuilderClass *klass); static void
garrow_array_builder_new(const std::shared_ptr<arrow::DataType> &type, GError **error, const char *context); static GArrowArrayBuilder *
garrow_array_builder_release_ownership(GArrowArrayBuilder *builder); void
garrow_array_builder_get_value_data_type(GArrowArrayBuilder *builder); GArrowDataType *
garrow_array_builder_get_value_type(GArrowArrayBuilder *builder); GArrowType
garrow_array_builder_finish(GArrowArrayBuilder *builder, GError **error); GArrowArray *
garrow_array_builder_reset(GArrowArrayBuilder *builder); void
garrow_array_builder_get_capacity(GArrowArrayBuilder *builder); gint64
garrow_array_builder_get_length(GArrowArrayBuilder *builder); gint64
garrow_array_builder_get_n_nulls(GArrowArrayBuilder *builder); gint64
garrow_array_builder_resize(GArrowArrayBuilder *builder, gint64 capacity, GError **error); gboolean
garrow_array_builder_reserve(GArrowArrayBuilder *builder, gint64 additional_capacity, GError **error); gboolean
garrow_array_builder_append_null(GArrowArrayBuilder *builder, GError **error); gboolean
garrow_array_builder_append_nulls(GArrowArrayBuilder *builder, gint64 n, GError **error); gboolean
garrow_array_builder_append_empty_value(GArrowArrayBuilder *builder, GError **error); gboolean
garrow_array_builder_append_empty_values(GArrowArrayBuilder *builder, gint64 n, GError **error); gboolean
garrow_null_array_builder_init(GArrowNullArrayBuilder *builder); static void
garrow_null_array_builder_class_init(GArrowNullArrayBuilderClass *klass); static void
garrow_null_array_builder_new(void); GArrowNullArrayBuilder *
garrow_null_array_builder_append_null(GArrowNullArrayBuilder *builder, GError **error); gboolean
garrow_null_array_builder_append_nulls(GArrowNullArrayBuilder *builder, gint64 n, GError **error); gboolean
garrow_boolean_array_builder_init(GArrowBooleanArrayBuilder *builder); static void
garrow_boolean_array_builder_class_init(GArrowBooleanArrayBuilderClass *klass); static void
garrow_boolean_array_builder_new(void); GArrowBooleanArrayBuilder *
garrow_boolean_array_builder_append(GArrowBooleanArrayBuilder *builder, gboolean value, GError **error); gboolean
garrow_boolean_array_builder_append_value(GArrowBooleanArrayBuilder *builder, gboolean value, GError **error); gboolean
garrow_boolean_array_builder_append_values(GArrowBooleanArrayBuilder *builder, const gboolean *values, gint64 values_length, const gboolean *is_valids, gint64 is_valids_length, GError **error); gboolean
garrow_boolean_array_builder_append_null(GArrowBooleanArrayBuilder *builder, GError **error); gboolean
garrow_boolean_array_builder_append_nulls(GArrowBooleanArrayBuilder *builder, gint64 n, GError **error); gboolean
garrow_int_array_builder_init(GArrowIntArrayBuilder *builder); static void
garrow_int_array_builder_class_init(GArrowIntArrayBuilderClass *klass); static void
garrow_int_array_builder_new(void); GArrowIntArrayBuilder *
garrow_int_array_builder_append(GArrowIntArrayBuilder *builder, gint64 value, GError **error); gboolean
garrow_int_array_builder_append_value(GArrowIntArrayBuilder *builder, gint64 value, GError **error); gboolean
garrow_int_array_builder_append_values(GArrowIntArrayBuilder *builder, const gint64 *values, gint64 values_length, const gboolean *is_valids, gint64 is_valids_length, GError **error); gboolean
garrow_int_array_builder_append_null(GArrowIntArrayBuilder *builder, GError **error); gboolean
garrow_int_array_builder_append_nulls(GArrowIntArrayBuilder *builder, gint64 n, GError **error); gboolean
garrow_uint_array_builder_init(GArrowUIntArrayBuilder *builder); static void
garrow_uint_array_builder_class_init(GArrowUIntArrayBuilderClass *klass); static void
garrow_uint_array_builder_new(void); GArrowUIntArrayBuilder *
garrow_uint_array_builder_append(GArrowUIntArrayBuilder *builder, guint64 value, GError **error); gboolean
garrow_uint_array_builder_append_value(GArrowUIntArrayBuilder *builder, guint64 value, GError **error); gboolean
garrow_uint_array_builder_append_values(GArrowUIntArrayBuilder *builder, const guint64 *values, gint64 values_length, const gboolean *is_valids, gint64 is_valids_length, GError **error); gboolean
garrow_uint_array_builder_append_null(GArrowUIntArrayBuilder *builder, GError **error); gboolean
garrow_uint_array_builder_append_nulls(GArrowUIntArrayBuilder *builder, gint64 n, GError **error); gboolean
garrow_int8_array_builder_init(GArrowInt8ArrayBuilder *builder); static void
garrow_int8_array_builder_class_init(GArrowInt8ArrayBuilderClass *klass); static void
garrow_int8_array_builder_new(void); GArrowInt8ArrayBuilder *
garrow_int8_array_builder_append(GArrowInt8ArrayBuilder *builder, gint8 value, GError **error); gboolean
garrow_int8_array_builder_append_value(GArrowInt8ArrayBuilder *builder, gint8 value, GError **error); gboolean
garrow_int8_array_builder_append_values(GArrowInt8ArrayBuilder *builder, const gint8 *values, gint64 values_length, const gboolean *is_valids, gint64 is_valids_length, GError **error); gboolean
garrow_int8_array_builder_append_null(GArrowInt8ArrayBuilder *builder, GError **error); gboolean
garrow_int8_array_builder_append_nulls(GArrowInt8ArrayBuilder *builder, gint64 n, GError **error); gboolean
garrow_uint8_array_builder_init(GArrowUInt8ArrayBuilder *builder); static void
garrow_uint8_array_builder_class_init(GArrowUInt8ArrayBuilderClass *klass); static void
garrow_uint8_array_builder_new(void); GArrowUInt8ArrayBuilder *
garrow_uint8_array_builder_append(GArrowUInt8ArrayBuilder *builder, guint8 value, GError **error); gboolean
garrow_uint8_array_builder_append_value(GArrowUInt8ArrayBuilder *builder, guint8 value, GError **error); gboolean
garrow_uint8_array_builder_append_values(GArrowUInt8ArrayBuilder *builder, const guint8 *values, gint64 values_length, const gboolean *is_valids, gint64 is_valids_length, GError **error); gboolean
garrow_uint8_array_builder_append_null(GArrowUInt8ArrayBuilder *builder, GError **error); gboolean
garrow_uint8_array_builder_append_nulls(GArrowUInt8ArrayBuilder *builder, gint64 n, GError **error); gboolean
garrow_int16_array_builder_init(GArrowInt16ArrayBuilder *builder); static void
garrow_int16_array_builder_class_init(GArrowInt16ArrayBuilderClass *klass); static void
garrow_int16_array_builder_new(void); GArrowInt16ArrayBuilder *
garrow_int16_array_builder_append(GArrowInt16ArrayBuilder *builder, gint16 value, GError **error); gboolean
garrow_int16_array_builder_append_value(GArrowInt16ArrayBuilder *builder, gint16 value, GError **error); gboolean
garrow_int16_array_builder_append_values(GArrowInt16ArrayBuilder *builder, const gint16 *values, gint64 values_length, const gboolean *is_valids, gint64 is_valids_length, GError **error); gboolean
garrow_int16_array_builder_append_null(GArrowInt16ArrayBuilder *builder, GError **error); gboolean
garrow_int16_array_builder_append_nulls(GArrowInt16ArrayBuilder *builder, gint64 n, GError **error); gboolean
garrow_uint16_array_builder_init(GArrowUInt16ArrayBuilder *builder); static void
garrow_uint16_array_builder_class_init(GArrowUInt16ArrayBuilderClass *klass); static void
garrow_uint16_array_builder_new(void); GArrowUInt16ArrayBuilder *
garrow_uint16_array_builder_append(GArrowUInt16ArrayBuilder *builder, guint16 value, GError **error); gboolean
garrow_uint16_array_builder_append_value(GArrowUInt16ArrayBuilder *builder, guint16 value, GError **error); gboolean
garrow_uint16_array_builder_append_values(GArrowUInt16ArrayBuilder *builder, const guint16 *values, gint64 values_length, const gboolean *is_valids, gint64 is_valids_length, GError **error); gboolean
garrow_uint16_array_builder_append_null(GArrowUInt16ArrayBuilder *builder, GError **error); gboolean
garrow_uint16_array_builder_append_nulls(GArrowUInt16ArrayBuilder *builder, gint64 n, GError **error); gboolean
garrow_int32_array_builder_init(GArrowInt32ArrayBuilder *builder); static void
garrow_int32_array_builder_class_init(GArrowInt32ArrayBuilderClass *klass); static void
garrow_int32_array_builder_new(void); GArrowInt32ArrayBuilder *
garrow_int32_array_builder_append(GArrowInt32ArrayBuilder *builder, gint32 value, GError **error); gboolean
garrow_int32_array_builder_append_value(GArrowInt32ArrayBuilder *builder, gint32 value, GError **error); gboolean
garrow_int32_array_builder_append_values(GArrowInt32ArrayBuilder *builder, const gint32 *values, gint64 values_length, const gboolean *is_valids, gint64 is_valids_length, GError **error); gboolean
garrow_int32_array_builder_append_null(GArrowInt32ArrayBuilder *builder, GError **error); gboolean
garrow_int32_array_builder_append_nulls(GArrowInt32ArrayBuilder *builder, gint64 n, GError **error); gboolean
garrow_uint32_array_builder_init(GArrowUInt32ArrayBuilder *builder); static void
garrow_uint32_array_builder_class_init(GArrowUInt32ArrayBuilderClass *klass); static void
garrow_uint32_array_builder_new(void); GArrowUInt32ArrayBuilder *
garrow_uint32_array_builder_append(GArrowUInt32ArrayBuilder *builder, guint32 value, GError **error); gboolean
garrow_uint32_array_builder_append_value(GArrowUInt32ArrayBuilder *builder, guint32 value, GError **error); gboolean
garrow_uint32_array_builder_append_values(GArrowUInt32ArrayBuilder *builder, const guint32 *values, gint64 values_length, const gboolean *is_valids, gint64 is_valids_length, GError **error); gboolean
garrow_uint32_array_builder_append_null(GArrowUInt32ArrayBuilder *builder, GError **error); gboolean
garrow_uint32_array_builder_append_nulls(GArrowUInt32ArrayBuilder *builder, gint64 n, GError **error); gboolean
garrow_int64_array_builder_init(GArrowInt64ArrayBuilder *builder); static void
garrow_int64_array_builder_class_init(GArrowInt64ArrayBuilderClass *klass); static void
garrow_int64_array_builder_new(void); GArrowInt64ArrayBuilder *
garrow_int64_array_builder_append(GArrowInt64ArrayBuilder *builder, gint64 value, GError **error); gboolean
garrow_int64_array_builder_append_value(GArrowInt64ArrayBuilder *builder, gint64 value, GError **error); gboolean
garrow_int64_array_builder_append_values(GArrowInt64ArrayBuilder *builder, const gint64 *values, gint64 values_length, const gboolean *is_valids, gint64 is_valids_length, GError **error); gboolean
garrow_int64_array_builder_append_null(GArrowInt64ArrayBuilder *builder, GError **error); gboolean
garrow_int64_array_builder_append_nulls(GArrowInt64ArrayBuilder *builder, gint64 n, GError **error); gboolean
garrow_uint64_array_builder_init(GArrowUInt64ArrayBuilder *builder); static void
garrow_uint64_array_builder_class_init(GArrowUInt64ArrayBuilderClass *klass); static void
garrow_uint64_array_builder_new(void); GArrowUInt64ArrayBuilder *
garrow_uint64_array_builder_append(GArrowUInt64ArrayBuilder *builder, guint64 value, GError **error); gboolean
garrow_uint64_array_builder_append_value(GArrowUInt64ArrayBuilder *builder, guint64 value, GError **error); gboolean
garrow_uint64_array_builder_append_values(GArrowUInt64ArrayBuilder *builder, const guint64 *values, gint64 values_length, const gboolean *is_valids, gint64 is_valids_length, GError **error); gboolean
garrow_uint64_array_builder_append_null(GArrowUInt64ArrayBuilder *builder, GError **error); gboolean
garrow_uint64_array_builder_append_nulls(GArrowUInt64ArrayBuilder *builder, gint64 n, GError **error); gboolean
garrow_float_array_builder_init(GArrowFloatArrayBuilder *builder); static void
garrow_float_array_builder_class_init(GArrowFloatArrayBuilderClass *klass); static void
garrow_float_array_builder_new(void); GArrowFloatArrayBuilder *
garrow_float_array_builder_append(GArrowFloatArrayBuilder *builder, gfloat value, GError **error); gboolean
garrow_float_array_builder_append_value(GArrowFloatArrayBuilder *builder, gfloat value, GError **error); gboolean
garrow_float_array_builder_append_values(GArrowFloatArrayBuilder *builder, const gfloat *values, gint64 values_length, const gboolean *is_valids, gint64 is_valids_length, GError **error); gboolean
garrow_float_array_builder_append_null(GArrowFloatArrayBuilder *builder, GError **error); gboolean
garrow_float_array_builder_append_nulls(GArrowFloatArrayBuilder *builder, gint64 n, GError **error); gboolean
garrow_double_array_builder_init(GArrowDoubleArrayBuilder *builder); static void
garrow_double_array_builder_class_init(GArrowDoubleArrayBuilderClass *klass); static void
garrow_double_array_builder_new(void); GArrowDoubleArrayBuilder *
garrow_double_array_builder_append(GArrowDoubleArrayBuilder *builder, gdouble value, GError **error); gboolean
garrow_double_array_builder_append_value(GArrowDoubleArrayBuilder *builder, gdouble value, GError **error); gboolean
garrow_double_array_builder_append_values(GArrowDoubleArrayBuilder *builder, const gdouble *values, gint64 values_length, const gboolean *is_valids, gint64 is_valids_length, GError **error); gboolean
garrow_double_array_builder_append_null(GArrowDoubleArrayBuilder *builder, GError **error); gboolean
garrow_double_array_builder_append_nulls(GArrowDoubleArrayBuilder *builder, gint64 n, GError **error); gboolean
garrow_binary_array_builder_init(GArrowBinaryArrayBuilder *builder); static void
garrow_binary_array_builder_class_init(GArrowBinaryArrayBuilderClass *klass); static void
garrow_binary_array_builder_new(void); GArrowBinaryArrayBuilder *
garrow_binary_array_builder_append(GArrowBinaryArrayBuilder *builder, const guint8 *value, gint32 length, GError **error); gboolean
garrow_binary_array_builder_append_value(GArrowBinaryArrayBuilder *builder, const guint8 *value, gint32 length, GError **error); gboolean
garrow_binary_array_builder_append_value_bytes(GArrowBinaryArrayBuilder *builder, GBytes *value, GError **error); gboolean
garrow_binary_array_builder_append_values(GArrowBinaryArrayBuilder *builder, GBytes **values, gint64 values_length, const gboolean *is_valids, gint64 is_valids_length, GError **error); gboolean
garrow_binary_array_builder_append_null(GArrowBinaryArrayBuilder *builder, GError **error); gboolean
garrow_binary_array_builder_append_nulls(GArrowBinaryArrayBuilder *builder, gint64 n, GError **error); gboolean
garrow_large_binary_array_builder_init(GArrowLargeBinaryArrayBuilder *builder); static void
garrow_large_binary_array_builder_class_init(GArrowLargeBinaryArrayBuilderClass *klass); static void
garrow_large_binary_array_builder_new(void); GArrowLargeBinaryArrayBuilder *
garrow_large_binary_array_builder_append_value(GArrowLargeBinaryArrayBuilder *builder, const guint8 *value, gint64 length, GError **error); gboolean
garrow_large_binary_array_builder_append_value_bytes(GArrowLargeBinaryArrayBuilder *builder, GBytes *value, GError **error); gboolean
garrow_large_binary_array_builder_append_values(GArrowLargeBinaryArrayBuilder *builder, GBytes **values, gint64 values_length, const gboolean *is_valids, gint64 is_valids_length, GError **error); gboolean
garrow_large_binary_array_builder_append_null(GArrowLargeBinaryArrayBuilder *builder, GError **error); gboolean
garrow_large_binary_array_builder_append_nulls(GArrowLargeBinaryArrayBuilder *builder, gint64 n, GError **error); gboolean
garrow_string_array_builder_init(GArrowStringArrayBuilder *builder); static void
garrow_string_array_builder_class_init(GArrowStringArrayBuilderClass *klass); static void
garrow_string_array_builder_new(void); GArrowStringArrayBuilder *
garrow_string_array_builder_append(GArrowStringArrayBuilder *builder, const gchar *value, GError **error); gboolean
garrow_string_array_builder_append_value(GArrowStringArrayBuilder *builder, const gchar *value, GError **error); gboolean
garrow_string_array_builder_append_string(GArrowStringArrayBuilder *builder, const gchar *value, GError **error); gboolean
garrow_string_array_builder_append_values(GArrowStringArrayBuilder *builder, const gchar **values, gint64 values_length, const gboolean *is_valids, gint64 is_valids_length, GError **error); gboolean
garrow_string_array_builder_append_strings(GArrowStringArrayBuilder *builder, const gchar **values, gint64 values_length, const gboolean *is_valids, gint64 is_valids_length, GError **error); gboolean
garrow_large_string_array_builder_init(GArrowLargeStringArrayBuilder *builder); static void
garrow_large_string_array_builder_class_init(GArrowLargeStringArrayBuilderClass *klass); static void
garrow_large_string_array_builder_new(void); GArrowLargeStringArrayBuilder *
garrow_large_string_array_builder_append_string(GArrowLargeStringArrayBuilder *builder, const gchar *value, GError **error); gboolean
garrow_large_string_array_builder_append_strings(GArrowLargeStringArrayBuilder *builder, const gchar **values, gint64 values_length, const gboolean *is_valids, gint64 is_valids_length, GError **error); gboolean
garrow_fixed_size_binary_array_builder_init( GArrowFixedSizeBinaryArrayBuilder *builder); static void
garrow_fixed_size_binary_array_builder_class_init( GArrowFixedSizeBinaryArrayBuilderClass *klass); static void
garrow_fixed_size_binary_array_builder_new( GArrowFixedSizeBinaryDataType *data_type); GArrowFixedSizeBinaryArrayBuilder *
garrow_fixed_size_binary_array_builder_append_value( GArrowFixedSizeBinaryArrayBuilder *builder, const guint8 *value, gint32 length, GError **error); gboolean
garrow_fixed_size_binary_array_builder_append_value_bytes( GArrowFixedSizeBinaryArrayBuilder *builder, GBytes *value, GError **error); gboolean
garrow_fixed_size_binary_array_builder_append_values( GArrowFixedSizeBinaryArrayBuilder *builder, GBytes **values, gint64 values_length, const gboolean *is_valids, gint64 is_valids_length, GError **error); gboolean
garrow_fixed_size_binary_array_builder_append_values_packed( GArrowFixedSizeBinaryArrayBuilder *builder, GBytes *values, const gboolean *is_valids, gint64 is_valids_length, GError **error); gboolean
garrow_date32_array_builder_init(GArrowDate32ArrayBuilder *builder); static void
garrow_date32_array_builder_class_init(GArrowDate32ArrayBuilderClass *klass); static void
garrow_date32_array_builder_new(void); GArrowDate32ArrayBuilder *
garrow_date32_array_builder_append(GArrowDate32ArrayBuilder *builder, gint32 value, GError **error); gboolean
garrow_date32_array_builder_append_value(GArrowDate32ArrayBuilder *builder, gint32 value, GError **error); gboolean
garrow_date32_array_builder_append_values(GArrowDate32ArrayBuilder *builder, const gint32 *values, gint64 values_length, const gboolean *is_valids, gint64 is_valids_length, GError **error); gboolean
garrow_date32_array_builder_append_null(GArrowDate32ArrayBuilder *builder, GError **error); gboolean
garrow_date32_array_builder_append_nulls(GArrowDate32ArrayBuilder *builder, gint64 n, GError **error); gboolean
garrow_date64_array_builder_init(GArrowDate64ArrayBuilder *builder); static void
garrow_date64_array_builder_class_init(GArrowDate64ArrayBuilderClass *klass); static void
garrow_date64_array_builder_new(void); GArrowDate64ArrayBuilder *
garrow_date64_array_builder_append(GArrowDate64ArrayBuilder *builder, gint64 value, GError **error); gboolean
garrow_date64_array_builder_append_value(GArrowDate64ArrayBuilder *builder, gint64 value, GError **error); gboolean
garrow_date64_array_builder_append_values(GArrowDate64ArrayBuilder *builder, const gint64 *values, gint64 values_length, const gboolean *is_valids, gint64 is_valids_length, GError **error); gboolean
garrow_date64_array_builder_append_null(GArrowDate64ArrayBuilder *builder, GError **error); gboolean
garrow_date64_array_builder_append_nulls(GArrowDate64ArrayBuilder *builder, gint64 n, GError **error); gboolean
garrow_timestamp_array_builder_init(GArrowTimestampArrayBuilder *builder); static void
garrow_timestamp_array_builder_class_init(GArrowTimestampArrayBuilderClass *klass); static void
garrow_timestamp_array_builder_new(GArrowTimestampDataType *data_type); GArrowTimestampArrayBuilder *
garrow_timestamp_array_builder_append(GArrowTimestampArrayBuilder *builder, gint64 value, GError **error); gboolean
garrow_timestamp_array_builder_append_value(GArrowTimestampArrayBuilder *builder, gint64 value, GError **error); gboolean
garrow_timestamp_array_builder_append_values(GArrowTimestampArrayBuilder *builder, const gint64 *values, gint64 values_length, const gboolean *is_valids, gint64 is_valids_length, GError **error); gboolean
garrow_timestamp_array_builder_append_null(GArrowTimestampArrayBuilder *builder, GError **error); gboolean
garrow_timestamp_array_builder_append_nulls(GArrowTimestampArrayBuilder *builder, gint64 n, GError **error); gboolean
garrow_time32_array_builder_init(GArrowTime32ArrayBuilder *builder); static void
garrow_time32_array_builder_class_init(GArrowTime32ArrayBuilderClass *klass); static void
garrow_time32_array_builder_new(GArrowTime32DataType *data_type); GArrowTime32ArrayBuilder *
garrow_time32_array_builder_append(GArrowTime32ArrayBuilder *builder, gint32 value, GError **error); gboolean
garrow_time32_array_builder_append_value(GArrowTime32ArrayBuilder *builder, gint32 value, GError **error); gboolean
garrow_time32_array_builder_append_values(GArrowTime32ArrayBuilder *builder, const gint32 *values, gint64 values_length, const gboolean *is_valids, gint64 is_valids_length, GError **error); gboolean
garrow_time32_array_builder_append_null(GArrowTime32ArrayBuilder *builder, GError **error); gboolean
garrow_time32_array_builder_append_nulls(GArrowTime32ArrayBuilder *builder, gint64 n, GError **error); gboolean
garrow_time64_array_builder_init(GArrowTime64ArrayBuilder *builder); static void
garrow_time64_array_builder_class_init(GArrowTime64ArrayBuilderClass *klass); static void
garrow_time64_array_builder_new(GArrowTime64DataType *data_type); GArrowTime64ArrayBuilder *
garrow_time64_array_builder_append(GArrowTime64ArrayBuilder *builder, gint64 value, GError **error); gboolean
garrow_time64_array_builder_append_value(GArrowTime64ArrayBuilder *builder, gint64 value, GError **error); gboolean
garrow_time64_array_builder_append_values(GArrowTime64ArrayBuilder *builder, const gint64 *values, gint64 values_length, const gboolean *is_valids, gint64 is_valids_length, GError **error); gboolean
garrow_time64_array_builder_append_null(GArrowTime64ArrayBuilder *builder, GError **error); gboolean
garrow_time64_array_builder_append_nulls(GArrowTime64ArrayBuilder *builder, gint64 n, GError **error); gboolean
garrow_binary_dictionary_array_builder_init(GArrowBinaryDictionaryArrayBuilder *builder); static void
garrow_binary_dictionary_array_builder_class_init(GArrowBinaryDictionaryArrayBuilderClass *klass); static void
garrow_binary_dictionary_array_builder_new(void); GArrowBinaryDictionaryArrayBuilder *
garrow_binary_dictionary_array_builder_append_null(GArrowBinaryDictionaryArrayBuilder *builder, GError **error); gboolean
garrow_binary_dictionary_array_builder_append_value(GArrowBinaryDictionaryArrayBuilder *builder, const guint8 *value, gint32 length, GError **error); gboolean
garrow_binary_dictionary_array_builder_append_value_bytes(GArrowBinaryDictionaryArrayBuilder *builder, GBytes *value, GError **error); gboolean
garrow_binary_dictionary_array_builder_append_array(GArrowBinaryDictionaryArrayBuilder *builder, GArrowBinaryArray *array, GError **error); gboolean
garrow_binary_dictionary_array_builder_append_indices(GArrowBinaryDictionaryArrayBuilder *builder, const gint64 *values, gint64 values_length, const gboolean *is_valids, gint64 is_valids_length, GError **error); gboolean
garrow_binary_dictionary_array_builder_get_dictionary_length(GArrowBinaryDictionaryArrayBuilder *builder); gint64
garrow_binary_dictionary_array_builder_finish_delta(GArrowBinaryDictionaryArrayBuilder* builder, GArrowArray **out_indices, GArrowArray **out_delta, GError **error); gboolean
garrow_binary_dictionary_array_builder_insert_memo_values(GArrowBinaryDictionaryArrayBuilder *builder, GArrowBinaryArray *values, GError **error); gboolean
garrow_binary_dictionary_array_builder_reset_full(GArrowBinaryDictionaryArrayBuilder *builder); void
garrow_string_dictionary_array_builder_init(GArrowStringDictionaryArrayBuilder *builder); static void
garrow_string_dictionary_array_builder_class_init(GArrowStringDictionaryArrayBuilderClass *klass); static void
garrow_string_dictionary_array_builder_new(void); GArrowStringDictionaryArrayBuilder *
garrow_string_dictionary_array_builder_append_null(GArrowStringDictionaryArrayBuilder *builder, GError **error); gboolean
garrow_string_dictionary_array_builder_append_string(GArrowStringDictionaryArrayBuilder *builder, const gchar *value, GError **error); gboolean
garrow_string_dictionary_array_builder_append_array(GArrowStringDictionaryArrayBuilder *builder, GArrowStringArray *array, GError **error); gboolean
garrow_string_dictionary_array_builder_append_indices(GArrowStringDictionaryArrayBuilder *builder, const gint64 *values, gint64 values_length, const gboolean *is_valids, gint64 is_valids_length, GError **error); gboolean
garrow_string_dictionary_array_builder_get_dictionary_length(GArrowStringDictionaryArrayBuilder *builder); gint64
garrow_string_dictionary_array_builder_finish_delta(GArrowStringDictionaryArrayBuilder* builder, GArrowArray **out_indices, GArrowArray **out_delta, GError **error); gboolean
garrow_string_dictionary_array_builder_insert_memo_values(GArrowStringDictionaryArrayBuilder *builder, GArrowStringArray *values, GError **error); gboolean
garrow_string_dictionary_array_builder_reset_full(GArrowStringDictionaryArrayBuilder *builder); void
garrow_list_array_builder_dispose(GObject *object); static void
garrow_list_array_builder_init(GArrowListArrayBuilder *builder); static void
garrow_list_array_builder_class_init(GArrowListArrayBuilderClass *klass); static void
garrow_list_array_builder_new(GArrowListDataType *data_type, GError **error); GArrowListArrayBuilder *
garrow_list_array_builder_append(GArrowListArrayBuilder *builder, GError **error); gboolean
garrow_list_array_builder_append_value(GArrowListArrayBuilder *builder, GError **error); gboolean
garrow_list_array_builder_append_null(GArrowListArrayBuilder *builder, GError **error); gboolean
garrow_list_array_builder_get_value_builder(GArrowListArrayBuilder *builder); GArrowArrayBuilder *
garrow_large_list_array_builder_dispose(GObject *object); static void
garrow_large_list_array_builder_init(GArrowLargeListArrayBuilder *builder); static void
garrow_large_list_array_builder_class_init(GArrowLargeListArrayBuilderClass *klass); static void
garrow_large_list_array_builder_new(GArrowLargeListDataType *data_type, GError **error); GArrowLargeListArrayBuilder *
garrow_large_list_array_builder_append_value(GArrowLargeListArrayBuilder *builder, GError **error); gboolean
garrow_large_list_array_builder_append_null(GArrowLargeListArrayBuilder *builder, GError **error); gboolean
garrow_large_list_array_builder_get_value_builder(GArrowLargeListArrayBuilder *builder); GArrowArrayBuilder *
garrow_struct_array_builder_dispose(GObject *object); static void
garrow_struct_array_builder_init(GArrowStructArrayBuilder *builder); static void
garrow_struct_array_builder_class_init(GArrowStructArrayBuilderClass *klass); static void
garrow_struct_array_builder_new(GArrowStructDataType *data_type, GError **error); GArrowStructArrayBuilder *
garrow_struct_array_builder_append(GArrowStructArrayBuilder *builder, GError **error); gboolean
garrow_struct_array_builder_append_value(GArrowStructArrayBuilder *builder, GError **error); gboolean
garrow_struct_array_builder_append_null(GArrowStructArrayBuilder *builder, GError **error); gboolean
garrow_struct_array_builder_get_field_builder(GArrowStructArrayBuilder *builder, gint i); GArrowArrayBuilder *
garrow_struct_array_builder_get_field_builders(GArrowStructArrayBuilder *builder); GList *
garrow_map_array_builder_dispose(GObject *object); static void
garrow_map_array_builder_init(GArrowMapArrayBuilder *builder); static void
garrow_map_array_builder_class_init(GArrowMapArrayBuilderClass *klass); static void
garrow_map_array_builder_new(GArrowMapDataType *data_type, GError **error); GArrowMapArrayBuilder *
garrow_map_array_builder_append_value(GArrowMapArrayBuilder *builder, GError **error); gboolean
garrow_map_array_builder_append_values(GArrowMapArrayBuilder *builder, const gint32 *offsets, gint64 offsets_length, const gboolean *is_valids, gint64 is_valids_length, GError **error); gboolean
garrow_map_array_builder_append_null(GArrowMapArrayBuilder *builder, GError **error); gboolean
garrow_map_array_builder_append_nulls(GArrowMapArrayBuilder *builder, gint64 n, GError **error); gboolean
garrow_map_array_builder_get_key_builder(GArrowMapArrayBuilder *builder); GArrowArrayBuilder *
garrow_map_array_builder_get_item_builder(GArrowMapArrayBuilder *builder); GArrowArrayBuilder *
garrow_map_array_builder_get_value_builder(GArrowMapArrayBuilder *builder); GArrowArrayBuilder *
garrow_decimal128_array_builder_init(GArrowDecimal128ArrayBuilder *builder); static void
garrow_decimal128_array_builder_class_init(GArrowDecimal128ArrayBuilderClass *klass); static void
garrow_decimal128_array_builder_new(GArrowDecimal128DataType *data_type); GArrowDecimal128ArrayBuilder *
garrow_decimal128_array_builder_append(GArrowDecimal128ArrayBuilder *builder, GArrowDecimal128 *value, GError **error); gboolean
garrow_decimal128_array_builder_append_value(GArrowDecimal128ArrayBuilder *builder, GArrowDecimal128 *value, GError **error); gboolean
garrow_decimal128_array_builder_append_values(GArrowDecimal128ArrayBuilder *builder, GArrowDecimal128 **values, gint64 values_length, const gboolean *is_valids, gint64 is_valids_length, GError **error); gboolean
garrow_decimal128_array_builder_append_null(GArrowDecimal128ArrayBuilder *builder, GError **error); gboolean
garrow_decimal256_array_builder_init(GArrowDecimal256ArrayBuilder *builder); static void
garrow_decimal256_array_builder_class_init(GArrowDecimal256ArrayBuilderClass *klass); static void
garrow_decimal256_array_builder_new(GArrowDecimal256DataType *data_type); GArrowDecimal256ArrayBuilder *
garrow_decimal256_array_builder_append_value(GArrowDecimal256ArrayBuilder *builder, GArrowDecimal256 *value, GError **error); gboolean
garrow_decimal256_array_builder_append_values(GArrowDecimal256ArrayBuilder *builder, GArrowDecimal256 **values, gint64 values_length, const gboolean *is_valids, gint64 is_valids_length, GError **error); gboolean
garrow_array_builder_new_raw(arrow::ArrayBuilder *arrow_builder, GType type); ArrowArrayBuilder *
garrow_array_builder_get_raw(GArrowArrayBuilder *builder); arrow::ArrayBuilder *
)
NB. =========================================================
NB. Buffer
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/buffer-classes.html
NB. =========================================================

bufferBindings =: lib 0 : 0
n *	garrow_buffer_finalize	(GObject *object); static void
n * i * *	garrow_buffer_set_property	(GObject *object, guint prop_id, const GValue *value, GParamSpec *pspec); static void
n * i * *	garrow_buffer_get_property	(GObject *object, guint prop_id, GValue *value, GParamSpec *pspec); static void
n *	garrow_buffer_init	(GArrowBuffer *object); static void
n * 	garrow_buffer_class_init	(GArrowBufferClass *klass); static void
* * i	garrow_buffer_new	(const guint8 *data, gint64 size); GArrowBuffer *
* *	garrow_buffer_new_bytes	(GBytes *data); GArrowBuffer *
i * *	garrow_buffer_equal	(GArrowBuffer *buffer, GArrowBuffer *other_buffer); gboolean
i * * i	garrow_buffer_equal_n_bytes	(GArrowBuffer *buffer, GArrowBuffer *other_buffer, gint64 n_bytes); gboolean
i *	garrow_buffer_is_mutable	(GArrowBuffer *buffer); gboolean
i *	garrow_buffer_get_capacity	(GArrowBuffer *buffer); gint64
* *	garrow_buffer_get_data	(GArrowBuffer *buffer); GBytes *
* *	garrow_buffer_get_mutable_data	(GArrowBuffer *buffer); GBytes *
i *	garrow_buffer_get_size	(GArrowBuffer *buffer); gint64
* *	garrow_buffer_get_parent	(GArrowBuffer *buffer); GArrowBuffer *
* * i i *	garrow_buffer_copy	(GArrowBuffer *buffer, gint64 start, gint64 size, GError **error); GArrowBuffer *
* * i i	garrow_buffer_slice	(GArrowBuffer *buffer, gint64 offset, gint64 size); GArrowBuffer *
n *	garrow_mutable_buffer_init	(GArrowMutableBuffer *object); static void
n *	garrow_mutable_buffer_class_init	(GArrowMutableBufferClass *klass); static void
* * i	garrow_mutable_buffer_new	(guint8 *data, gint64 size); GArrowMutableBuffer *
* *	garrow_mutable_buffer_new_bytes	(GBytes *data); GArrowMutableBuffer *
* * i i	garrow_mutable_buffer_slice	(GArrowMutableBuffer *buffer, gint64 offset, gint64 size); GArrowMutableBuffer *
i * i *i i *	garrow_mutable_buffer_set_data	(GArrowMutableBuffer *buffer, gint64 offset, const guint8 *data, gint64 size, GError **error); gboolean
n *	garrow_resizable_buffer_init	(GArrowResizableBuffer *object); static void
n *	garrow_resizable_buffer_class_init	(GArrowResizableBufferClass *klass); static void
* i *	garrow_resizable_buffer_new	(gint64 initial_size, GError **error); GArrowResizableBuffer *
i * i *	garrow_resizable_buffer_resize	(GArrowResizableBuffer *buffer, gint64 new_size, GError **error); gboolean
i * i *	garrow_resizable_buffer_reserve	(GArrowResizableBuffer *buffer, gint64 new_capacity, GError **error); gboolean
* *	garrow_buffer_new_raw	(std::shared_ptr<arrow::Buffer> *arrow_buffer); ArrowBuffer *
* * *	garrow_buffer_new_raw_bytes	(std::shared_ptr<arrow::Buffer> *arrow_buffer, GBytes *data); GArrowBuffer *
* * *	garrow_buffer_new_raw_parent	(std::shared_ptr<arrow::Buffer> *arrow_buffer, GArrowBuffer *parent); GArrowBuffer *
* *	garrow_buffer_get_raw	(GArrowBuffer *buffer); std::shared_ptr<arrow::Buffer>
* *	garrow_mutable_buffer_new_raw	(std::shared_ptr<arrow::MutableBuffer> *arrow_buffer); GArrowMutableBuffer *
* * *	garrow_mutable_buffer_new_raw_bytes	(std::shared_ptr<arrow::MutableBuffer> *arrow_buffer, GBytes *data); GArrowMutableBuffer *
* *	garrow_resizable_buffer_new_raw	(std::shared_ptr<arrow::ResizableBuffer> *arrow_buffer); GArrowResizableBuffer *
)
NB. =========================================================
NB. Codec
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/GArrowCodec.html
NB. =========================================================
codecBindings =: lib 0 : 0
* i *	garrow_codec_new	(GArrowCompressionType type,GError **error); GArrowCodec *
* *	garrow_codec_get_name	(GArrowCodec *codec); const gchar *
i *	garrow_codec_get_compression_type	(GArrowCodec *codec); GArrowCompressionType
i *	garrow_codec_get_compression_level	(GArrowCodec *codec); gint
)
NB. =========================================================
NB. Basic Data Type
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/basic-data-type-classes.html
NB. =========================================================

basicDatatypeBindings =: lib 0 : 0
* * *	garrow_data_type_import	(gpointer c_abi_schema, GError **error); GArrowDataType *
* * *	garrow_data_type_export	(GArrowDataType *data_type, GError **error); gpointer	
i * *	garrow_data_type_equal	(GArrowDataType *data_type, GArrowDataType *other_data_type); gboolean
*c *	garrow_data_type_to_string	(GArrowDataType *data_type); gchar *
i *	garrow_data_type_get_id	(GArrowDataType *data_type); GArrowType
*c *	garrow_data_type_get_name	(GArrowDataType *data_type); gchar *
i *	garrow_fixed_width_data_type_get_bit_width	(GArrowFixedWidthDataType *data_type); gint
*	garrow_null_data_type_new	(void); GArrowNullDataType *
*	garrow_boolean_data_type_new	(void); GArrowBooleanDataType *
i *	garrow_integer_data_type_is_signed	(GArrowIntegerDataType *data_type); gboolean
*	garrow_int8_data_type_new	(void);GArrowInt8DataType *
*	garrow_uint8_data_type_new	(void); GArrowUInt8DataType *
*	garrow_int16_data_type_new	(void); GArrowInt16DataType *
*	garrow_uint16_data_type_new	(void); GArrowUInt16DataType *
*	garrow_int32_data_type_new	(void); GArrowInt32DataType *
*	garrow_uint32_data_type_new	(void); GArrowUInt32DataType *
*	garrow_int64_data_type_new	(void); GArrowInt64DataType *
*	garrow_uint64_data_type_new	(void); GArrowUInt64DataType *
*	garrow_float_data_type_new	(void); GArrowFloatDataType *
*	garrow_double_data_type_new	(void); GArrowDoubleDataType *
*	garrow_binary_data_type_new	(void); GArrowBinaryDataType *
* i	garrow_fixed_size_binary_data_type_new	(gint32 byte_width); GArrowFixedSizeBinaryDataType *
i *	garrow_fixed_size_binary_data_type_get_byte_width	(GArrowFixedSizeBinaryDataType *data_type); gint32
*	garrow_large_binary_data_type_new	(void); GArrowLargeBinaryDataType *
*	garrow_string_data_type_new	(void); GArrowStringDataType *
*	garrow_large_string_data_type_new	(void); GArrowLargeStringDataType *
*	garrow_date32_data_type_new	(void); GArrowDate32DataType *
*	garrow_date64_data_type_new	(void); GArrowDate64DataType *
* i	garrow_timestamp_data_type_new	(GArrowTimeUnit unit); GArrowTimestampDataType *
i *	garrow_timestamp_data_type_get_unit	(GArrowTimestampDataType *timestamp_data_type); GArrowTimeUnit
i *	garrow_time_data_type_get_unit	(GArrowTimeDataType *time_data_type); GArrowTimeUnit
* i *	garrow_time32_data_type_new	(GArrowTimeUnit unit, GError **error); GArrowTime32DataType *
* i *	garrow_time64_data_type_new	(GArrowTimeUnit unit, GError **error); GArrowTime64DataType *
* i i	garrow_decimal_data_type_new	(gint32 precision, gint32 scale); GArrowDecimalDataType *
i *	garrow_decimal_data_type_get_precision	(GArrowDecimalDataType *decimal_data_type); gint32
i *	garrow_decimal_data_type_get_scale	(GArrowDecimalDataType *decimal_data_type); gint32
i	garrow_decimal128_data_type_max_precision	(); gint32
* i i	garrow_decimal128_data_type_new	(gint32 precision, gint32 scale); GArrowDecimal128DataType *
i	garrow_decimal256_data_type_max_precision	(); gint32
* i i	garrow_decimal256_data_type_new	(gint32 precision, gint32 scale); GArrowDecimal256DataType *
*c *	garrow_extension_data_type_get_extension_name	(GArrowExtensionDataType *data_type); gchar *
* * *	garrow_extension_data_type_wrap_array	(GArrowExtensionDataType *data_type, GArrowArray *storage); GArrowExtensionArray *
* * *	garrow_extension_data_type_wrap_chunked_array	(GArrowExtensionDataType *data_type, GArrowChunkedArray *storage); GArrowChunkedArray *
*	garrow_extension_data_type_registry_default	(void); GArrowExtensionDataTypeRegistry *
i * * *	garrow_extension_data_type_registry_register	(GArrowExtensionDataTypeRegistry *registry, GArrowExtensionDataType *data_type, GError **error); gboolean
i * *c *	garrow_extension_data_type_registry_unregister	(GArrowExtensionDataTypeRegistry *registry, const gchar *name, GError **error); gboolean
* * *c	garrow_extension_data_type_registry_lookup	(GArrowExtensionDataTypeRegistry *registry, const gchar *name); GArrowExtensionDataType *
*	garrow_data_type_get_type	(void) *                  
*	garrow_fixed_width_data_type_get_type	(void) *
*	garrow_boolean_data_type_get_type	(void) *
*	garrow_numeric_data_type_get_type	(void) *
*	garrow_integer_data_type_get_type	(void) *
*	garrow_int8_data_type_get_type	(void) *
*	garrow_uint8_data_type_get_type	(void) *
*	garrow_int16_data_type_get_type	(void) *
*	garrow_uint16_data_type_get_type	(void) *
*	garrow_int32_data_type_get_type	(void) *
*	garrow_uint32_data_type_get_type	(void) *
*	garrow_int64_data_type_get_type	(void) *
*	garrow_uint64_data_type_get_type	(void) *
*	garrow_float_data_type_get_type	(void) *
*	garrow_double_data_type_get_type	(void) *
*	garrow_binary_data_type_get_type	(void) *           
*	garrow_fixed_size_binary_data_type_get_type	(void) *
*	garrow_large_binary_data_type_get_type	(void) *
*	garrow_string_data_type_get_type	(void) *
*	garrow_large_string_data_type_get_type	(void) *
*	garrow_date32_data_type_get_type	(void) *
*	garrow_date64_data_type_get_type	(void) *
*	garrow_timestamp_data_type_get_type	(void) *
*	garrow_time_data_type_get_type	(void) *
*	garrow_time32_data_type_get_type	(void) *
*	garrow_time64_data_type_get_type	(void) *
*	garrow_decimal_data_type_get_type	(void) *
*	garrow_decimal128_data_type_get_type	(void) *
*	garrow_decimal256_data_type_get_type	(void) *
*	garrow_extension_data_type_get_type	(void) *
)


NB. =========================================================
NB. Composite Data Type
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/composite-data-type-classes.html
NB. =========================================================

compositeDataTypeBindings =: lib 0 : 0
* *	garrow_list_data_type_new	(GArrowField *field);GArrowListDataType *
* *	garrow_list_data_type_get_value_field	(GArrowListDataType *list_data_type); GArrowField *
* *	garrow_list_data_type_get_field	(GArrowListDataType *list_data_type); GArrowField *
* *	garrow_large_list_data_type_new 	(GArrowField *field); GArrowLargeListDataType *
* *	garrow_large_list_data_type_get_field 	(GArrowLargeListDataType *large_list_data_type);GArrowField *
* *	garrow_struct_data_type_new	(GList *fields);GArrowStructDataType *
i *	garrow_struct_data_type_get_n_fields	(GArrowStructDataType *struct_data_type);gint
* *	garrow_struct_data_type_get_fields	(GArrowStructDataType *struct_data_type);GList *
* * i	garrow_struct_data_type_get_field	(GArrowStructDataType *struct_data_type, gint i); GArrowField *
* * *c	garrow_struct_data_type_get_field_by_name	(GArrowStructDataType *struct_data_type, const gchar *name); GArrowField *
i * *c	garrow_struct_data_type_get_field_index	(GArrowStructDataType *struct_data_type, const gchar *name); gint
* * *	garrow_map_data_type_new	(GArrowDataType *key_type, GArrowDataType *item_type); GArrowMapDataType *
* *	garrow_map_data_type_get_key_type	(GArrowMapDataType *map_data_type); GArrowDataType *
* *	garrow_map_data_type_get_item_type	(GArrowMapDataType *map_data_type); GArrowDataType *
i *	garrow_union_data_type_get_n_fields	(GArrowUnionDataType *union_data_type); gint
* *	garrow_union_data_type_get_fields	(GArrowUnionDataType *union_data_type); GList *
* * i	garrow_union_data_type_get_field	(GArrowUnionDataType *union_data_type, gint i); GArrowField *
* * *	garrow_union_data_type_get_type_codes	(GArrowUnionDataType *union_data_type, gsize *n_type_codes); gint8 *
* * * i	garrow_sparse_union_data_type_new	(GList *fields, gint8 *type_codes, gsize n_type_codes); GArrowSparseUnionDataType *
* * * i	garrow_dense_union_data_type_new	(GList *fields, gint8 *type_codes, gsize n_type_codes); GArrowDenseUnionDataType *
* * * i	garrow_dictionary_data_type_new	(GArrowDataType *index_data_type, GArrowDataType *value_data_type, gboolean ordered); GArrowDictionaryDataType *
* *	garrow_dictionary_data_type_get_index_data_type	(GArrowDictionaryDataType *dictionary_data_type); GArrowDataType *
* *	garrow_dictionary_data_type_get_value_data_type	(GArrowDictionaryDataType *dictionary_data_type); GArrowDataType *
i *	garrow_dictionary_data_type_is_ordered	(GArrowDictionaryDataType *dictionary_data_type); gboolean
)
NB. =========================================================
NB. Error
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/arrow-glib-GArrowError.html
NB. =========================================================
errorBindings =: lib 0 : 0
b * & *	garrow_error_check	(GError **error, const arrow::Status &status, const char *context); boolean
* &	garrow_error_from_status	(const arrow::Status &status); GArrowError
* * *	garrow_error_to_status_code	(GError *error, arrow::StatusCode default_code); arrow::StatusCode
* * *	garrow_error_to_status	(GError *error, arrow::StatusCode default_code, const char *context); arrow::Status
)
NB. Parquet

NB. =========================================================
NB. Reader
NB. https://arrow.apache.org/docs/c_glib/parquet-glib/GParquetArrowFileReader.html

parquetReaderBindings =: lib 0 : 0
* * *	gparquet_arrow_file_reader_new_arrow	(GArrowSeekableInputStream *source, GError **error); * GParquetArrowFileReader
* *c *	gparquet_arrow_file_reader_new_path	(const gchar *path, GError **error); * GParquetArrowFileReader
* * *	gparquet_arrow_file_reader_read_table	(GParquetArrowFileReader *reader, GError **error); * GArrowTable
* *i i *i i i	gparquet_arrow_file_reader_read_row_group	(GParquetArrowFileReader *reader, gint row_group_index, gint *column_indices, gsize n_column_indices, GError **error); * GArrowTable
* * * 	gparquet_arrow_file_reader_get_schema 	(GParquetArrowFileReader *reader, GError **error); * GArrowSchema
* * i * 	gparquet_arrow_file_reader_read_column_data	(GParquetArrowFileReader *reader, gint i, GError **error); * GArrowChunkedArray
i *	gparquet_arrow_file_reader_get_n_row_groups	(GParquetArrowFileReader *reader); gint
n * i	gparquet_arrow_file_reader_set_use_threads	(GParquetArrowFileReader *reader, gboolean use_threads); void
)

NB. =========================================================
NB. Writer
NB. https://arrow.apache.org/docs/c_glib/parquet-glib/GParquetArrowFileWriter.html

parquetWriterBindings =: lib 0 : 0
*	gparquet_writer_properties_new	(void); GParquetWriterProperties
n * c *c	gparquet_writer_properties_set_compression	(GParquetWriterProperties *properties, GArrowCompressionType compression_type, const gchar *path); void
? * *c	gparquet_writer_properties_get_compression_path	(GParquetWriterProperties *properties, const gchar *path); GArrowCompressionType
n * *	gparquet_writer_properties_enable_dictionary	(GParquetWriterProperties *properties, const gchar *path); void
n * *	gparquet_writer_properties_disable_dictionary	(GParquetWriterProperties *properties, const gchar *path); void
i * *	gparquet_writer_properties_is_dictionary_enabled	(GParquetWriterProperties *properties, const gchar *path); gboolean
n *	gparquet_writer_properties_set_dictionary_page_size_limit	(GParquetWriterProperties *properties, gint64 limit); void
x *	gparquet_writer_properties_get_dictionary_page_size_limit	(GParquetWriterProperties *properties); gint64
n * x	gparquet_writer_properties_set_batch_size	(GParquetWriterProperties *properties, gint64 batch_size); void
x *	gparquet_writer_properties_get_batch_size	(GParquetWriterProperties *properties); gint64
n * x	gparquet_writer_properties_set_max_row_group_length	(GParquetWriterProperties *properties, gint64 length); void
x *	gparquet_writer_properties_get_max_row_group_length	(GParquetWriterProperties *properties); gint64
n * x	gparquet_writer_properties_set_data_page_size		(GParquetWriterProperties *properties, gint64 data_page_size); void
x *	gparquet_writer_properties_get_data_page_size		(GParquetWriterProperties *properties); gint64
* * * * *	gparquet_arrow_file_writer_new_arrow	(GArrowSchema *schema, GArrowOutputStream *sink,GParquetWriterProperties *writer_properties,GError **error); GParquetArrowFileWriter *
* * * * *	gparquet_arrow_file_writer_new_path	(GArrowSchema *schema, const gchar *path, GParquetWriterProperties *writer_properties, GError **error); GParquetArrowFileWriter *
i * * x *	gparquet_arrow_file_writer_write_table	(GParquetArrowFileWriter *writer, GArrowTable *table, guint64 chunk_size, GError **error); gboolean
i * *	gparquet_arrow_file_writer_close	(GParquetArrowFileWriter *writer, GError **error); gboolean
)

NB. =========================================================
NB. ArrowSchema
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/GArrowSchema.html

schemaBindings =: lib 0 : 0
* *	garrow_schema_new	(GList *fields); GArrowSchema *
i * *	garrow_schema_equal	(GArrowSchema *schema, GArrowSchema *other_schema); gboolean         
* * i	garrow_schema_get_field	(GArrowSchema *schema, guint i); GArrowField *
* * *	garrow_schema_get_field_by_name	(GArrowSchema *schema,const gchar *name); GArrowField *
i * *	garrow_schema_get_field_index	(GArrowSchema *schema,const gchar *name); gint
i *	garrow_schema_n_fields	(GArrowSchema *schema); guint
* *	garrow_schema_get_fields	(GArrowSchema *schema); GList *
* *	garrow_schema_to_string	(GArrowSchema *schema); gchar *
* * i	garrow_schema_to_string_metadata	(GArrowSchema *schema, gboolean show_metadata); gchar *
* * i * *	garrow_schema_add_field	(GArrowSchema *schema, guint i, GArrowField *field, GError **error); GArrowSchema *
* * i *	garrow_schema_remove_field	(GArrowSchema *schema,guint i, GError **error); GArrowSchema *
* * i * *	garrow_schema_replace_field	(GArrowSchema *schema,guint i, GArrowField *field, GError **error); GArrowSchema *
)


NB. =========================================================
NB. ArrowField
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/GArrowField.html

fieldBindings =: lib 0 : 0
* * *	garrow_field_new	(const gchar *name, GArrowDataType *data_type); GArrowField *
* * * i	garrow_field_new_full	(const gchar *name, GArrowDataType *data_type, gboolean nullable); GArrowField *
* *	garrow_field_get_name	(GArrowField *field); const gchar *
* *	garrow_field_get_data_type	(GArrowField *field); GArrowDataType *
i *	garrow_field_is_nullable	(GArrowField *field); gboolean
i * *	garrow_field_equal	(GArrowField *field, GArrowField *other_field); gboolean
* *	garrow_field_to_string	(GArrowField *field); gchar *
* * i	garrow_field_to_string_metadata	(GArrowField *field, gboolean show_metadata); gchar *
i *	garrow_field_has_metadata	(GArrowField *field); gboolean
* *	garrow_field_get_metadata	(GArrowField *field); GHashTable *
* * *	garrow_field_with_metadata	(GArrowField *field, GHashTable *metadata); GArrowField *
* * *	garrow_field_with_merged_metadata	(GArrowField *field, GHashTable *metadata); GArrowField *
* *	garrow_field_remove_metadata	(GArrowField *field); GArrowField *
)

NB. =========================================================
NB. ArrowTable
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/GArrowTable.html

tableBindings =: lib 0 : 0
* * * *	garrow_table_new_values	(GArrowSchema *schema, GList *values, GError **error); GArrowTable *
* * * * i * 	garrow_table_new_chunked_arrays	(GArrowSchema *schema, GArrowChunkedArray **chunked_arrays, gsize n_chunked_arrays, GError **error); GArrowTable * 
* * * i *	garrow_table_new_arrays	(GArrowSchema *schema, GArrowArray **arrays, gsize n_arrays, GError **error); GArrowTable *
* * * i *	garrow_table_new_record_batches	(GArrowSchema *schema, GArrowRecordBatch **record_batches, gsize n_record_batches, GError **error); GArrowTable *
i * *	garrow_table_equal	(GArrowTable *table, GArrowTable *other_table); gboolean
i * * i	garrow_table_equal_metadata	(GArrowTable *table, GArrowTable *other_table, gboolean check_metadata); gboolean
* *	garrow_table_get_schema	(GArrowTable *table); GArrowSchema *
* * i	garrow_table_get_column_data	(GArrowTable *table, gint i); GArrowChunkedArray *
i *	garrow_table_get_n_columns	(GArrowTable *table); guint
l *	garrow_table_get_n_rows	(GArrowTable *table); guint64
* * i * * *	garrow_table_add_column	(GArrowTable *table, guint i, GArrowField *field, GArrowChunkedArray *chunked_array, GError **error); GArrowTable *
* * i *	garrow_table_remove_column	(GArrowTable *table, guint i, GError **error); GArrowTable *
* * i * * *	garrow_table_replace_column	(GArrowTable *table, guint i, GArrowField *field, GArrowChunkedArray *chunked_array, GError **error); GArrowTable *
* * *	garrow_table_to_string	(GArrowTable *table, GError **error); gchar *
* * * * *	garrow_table_concatenate 	(GArrowTable *table, GList *other_tables, GArrowTableConcatenateOptions *options, GError **error); GArrowTable *
*	garrow_table_concatenate_options_new	(void);	GArrowTableConcatenateOptions *
* * x x	garrow_table_slice	(GArrowTable *table, gint64 offset, gint64 length); GArrowTable *
* * *	garrow_table_combine_chunks	(GArrowTable *table, GError **error); GArrowTable *
n *	garrow_feather_write_properties_finalize	(GObject *object); static void 
n * i * *	garrow_feather_write_properties_set_property	(GObject *object, guint prop_id, const GValue *value, GParamSpec *pspec); static void 
n * i * *	garrow_feather_write_properties_get_property	(GObject *object, guint prop_id, GValue *value, GParamSpec *pspec); static void 
n *	garrow_feather_write_properties_init	(GArrowFeatherWriteProperties *object); static void 
n *	garrow_feather_write_properties_class_init	(GArrowFeatherWritePropertiesClass *klass); static void 
* n	garrow_feather_write_properties_new	(void); GArrowFeatherWriteProperties *
i * * * *	garrow_table_write_as_feather	(GArrowTable *table, GArrowOutputStream *sink, GArrowFeatherWriteProperties *properties, GError **error); gboolean 
)

NB. =========================================================
NB. Record Batch
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/record-batch.html
NB. =========================================================
recordBatchBindings =: lib 0 : 0
n *	garrow_record_batch_finalize	(GObject *object); static void
n * i * *	garrow_record_batch_set_property	(GObject *object, guint prop_id, const GValue *value, GParamSpec *pspec); static void
n * i * *	garrow_record_batch_get_property	(GObject *object, guint prop_id, GValue *value, GParamSpec *pspec); static void
n *	garrow_record_batch_init	(GArrowRecordBatch *object); static void
n *	garrow_record_batch_class_init	(GArrowRecordBatchClass *klass); static void
* * i * *	garrow_record_batch_new	(GArrowSchema *schema, guint32 n_rows, GList *columns, GError **error); GArrowRecordBatch *
i * *	garrow_record_batch_equal	(GArrowRecordBatch *record_batch, GArrowRecordBatch *other_record_batch); gboolean
i * * c	garrow_record_batch_equal_metadata	(GArrowRecordBatch *record_batch, GArrowRecordBatch *other_record_batch, gboolean check_metadata); gboolean
* *	garrow_record_batch_get_schema	(GArrowRecordBatch *record_batch); GArrowSchema *
* * i	garrow_record_batch_get_column_data	(GArrowRecordBatch *record_batch, gint i); GArrowArray *
* * i	garrow_record_batch_get_column_name	(GArrowRecordBatch *record_batch, gint i); const gchar *
i *	garrow_record_batch_get_n_columns	(GArrowRecordBatch *record_batch); guint
x *	garrow_record_batch_get_n_rows	(GArrowRecordBatch *record_batch); gint64
* * x x	garrow_record_batch_slice	(GArrowRecordBatch *record_batch, gint64 offset, gint64 length); GArrowRecordBatch *
* * *	garrow_record_batch_to_string	(GArrowRecordBatch *record_batch, GError **error); gchar *
* * i * * *	garrow_record_batch_add_column	(GArrowRecordBatch *record_batch, guint i, GArrowField *field, GArrowArray *column, GError **error); GArrowRecordBatch *
* * i *	garrow_record_batch_remove_column	(GArrowRecordBatch *record_batch, guint i, GError **error); GArrowRecordBatch *
* * * *	garrow_record_batch_serialize	(GArrowRecordBatch *record_batch, GArrowWriteOptions *options, GError **error); GArrowBuffer *
n *	garrow_record_batch_iterator_finalize	(GObject *object); static void
n * i * *	garrow_record_batch_iterator_set_property	(GObject *object, guint prop_id, const GValue *value, GParamSpec *pspec); static void
n *	garrow_record_batch_iterator_init	(GArrowRecordBatchIterator *object); static void
n *	garrow_record_batch_iterator_class_init	(GArrowRecordBatchIteratorClass *klass); static void
* *	garrow_record_batch_iterator_new	(GList *record_batches); GArrowRecordBatchIterator *
* * *	garrow_record_batch_iterator_next	(GArrowRecordBatchIterator *iterator, GError **error); GArrowRecordBatch *
i * *	garrow_record_batch_iterator_equal	(GArrowRecordBatchIterator *iterator, GArrowRecordBatchIterator *other_iterator); gboolean
* * *	garrow_record_batch_iterator_to_list	(GArrowRecordBatchIterator *iterator, GError **error); GList*
* *	garrow_record_batch_new_raw	(std::shared_ptr<arrow::RecordBatch> *arrow_record_batch); ArrowRecordBatch *
* *	garrow_record_batch_get_raw	(GArrowRecordBatch *record_batch); std::shared_ptr<arrow::RecordBatch>
* *	garrow_record_batch_iterator_new_raw	(arrow::RecordBatchIterator *arrow_iterator); GArrowRecordBatchIterator *
* *	garrow_record_batch_iterator_get_raw	(GArrowRecordBatchIterator *iterator); arrow::RecordBatchIterator *
)

NB. =========================================================
NB. Chunked Array
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/GArrowChunkedArray.html

chunkedArrayBindings =: lib 0 : 0
n *	garrow_chunked_array_finalize	(GObject *object); static void
n * i * *	garrow_chunked_array_set_property	(GObject *object, guint prop_id, const GValue *value, GParamSpec *pspec); static void
n * i * *	garrow_chunked_array_get_property	(GObject *object, guint prop_id, GValue *value, GParamSpec *pspec); static void
n *	garrow_chunked_array_init	(GArrowChunkedArray *object); static void
n *	garrow_chunked_array_class_init	(GArrowChunkedArrayClass *klass); static void
* *	garrow_chunked_array_new	(GList *chunks); GArrowChunkedArray *
i * *	garrow_chunked_array_equal	(GArrowChunkedArray *chunked_array, GArrowChunkedArray *other_chunked_array); gboolean
* *	garrow_chunked_array_get_value_data_type	(GArrowChunkedArray *chunked_array); GArrowDataType *
i *	garrow_chunked_array_get_value_type	(GArrowChunkedArray *chunked_array); GArrowType
x *	garrow_chunked_array_get_length	(GArrowChunkedArray *chunked_array); guint64
x *	garrow_chunked_array_get_n_rows	(GArrowChunkedArray *chunked_array); guint64
x *	garrow_chunked_array_get_n_nulls	(GArrowChunkedArray *chunked_array); guint64
x *	garrow_chunked_array_get_n_chunks	(GArrowChunkedArray *chunked_array); guint
* * i	garrow_chunked_array_get_chunk	(GArrowChunkedArray *chunked_array, guint i); GArrowArray *
* *	garrow_chunked_array_get_chunks	(GArrowChunkedArray *chunked_array); GList *
* * x x	garrow_chunked_array_slice	(GArrowChunkedArray *chunked_array, guint64 offset, guint64 length); GArrowChunkedArray *
* * *	garrow_chunked_array_to_string	(GArrowChunkedArray *chunked_array, GError **error); gchar *
* * *	garrow_chunked_array_combine	(GArrowChunkedArray *chunked_array, GError **error); GArrowArray *
* *	garrow_chunked_array_new_raw	(std::shared_ptr<arrow::ChunkedArray> *arrow_chunked_array); ArrowChunkedArray *
* *	garrow_chunked_array_get_raw	(GArrowChunkedArray *chunked_array); std::shared_ptr<arrow::ChunkedArray>
)
NB. =========================================================
NB. Table Builder
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/table-builder-classes.html
NB. =========================================================

tableBuilderBindings =: lib 0 : 0
ADD TYPES
garrow_record_batch_builder_finalize(GObject *object); static void
garrow_record_batch_builder_set_property(GObject *object, guint prop_id, const GValue *value, GParamSpec *pspec); static void
garrow_record_batch_builder_get_property(GObject *object, guint prop_id, GValue *value, GParamSpec *pspec); static void
garrow_record_batch_builder_init(GArrowRecordBatchBuilder *builder); static void
garrow_record_batch_builder_class_init(GArrowRecordBatchBuilderClass *klass); static void
garrow_record_batch_builder_new(GArrowSchema *schema, GError **error); GArrowRecordBatchBuilder *
garrow_record_batch_builder_get_initial_capacity(GArrowRecordBatchBuilder *builder); gint64
garrow_record_batch_builder_set_initial_capacity(GArrowRecordBatchBuilder *builder, gint64 capacity); void
garrow_record_batch_builder_get_schema(GArrowRecordBatchBuilder *builder); GArrowSchema *
garrow_record_batch_builder_get_n_fields(GArrowRecordBatchBuilder *builder); gint
garrow_record_batch_builder_get_n_columns(GArrowRecordBatchBuilder *builder); gint
garrow_record_batch_builder_get_field(GArrowRecordBatchBuilder *builder, gint i); GArrowArrayBuilder *
garrow_record_batch_builder_get_column_builder(GArrowRecordBatchBuilder *builder, gint i); GArrowArrayBuilder *
garrow_record_batch_builder_flush(GArrowRecordBatchBuilder *builder , GError **error); GArrowRecordBatch *
garrow_record_batch_builder_new_raw(arrow::RecordBatchBuilder *arrow_builder); ArrowRecordBatchBuilder *
garrow_record_batch_builder_get_raw(GArrowRecordBatchBuilder *builder); arrow::RecordBatchBuilder *
)
NB. =========================================================
NB. Tensor
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/GArrowTensor.html
NB. =========================================================

tensorBindings =: lib 0 : 0
ADD TYPES
garrow_tensor_dispose(GObject *object); static void
garrow_tensor_finalize(GObject *object); static void
garrow_tensor_set_property(GObject *object, guint prop_id, const GValue *value, GParamSpec *pspec); static void
garrow_tensor_get_property(GObject *object, guint prop_id, GValue *value, GParamSpec *pspec); static void
garrow_tensor_init(GArrowTensor *object); static void
garrow_tensor_class_init(GArrowTensorClass *klass); static void
garrow_tensor_new(GArrowDataType *data_type, GArrowBuffer *data, gint64 *shape, gsize n_dimensions, gint64 *strides, gsize n_strides, gchar **dimension_names, gsize n_dimension_names); GArrowTensor *
garrow_tensor_equal(GArrowTensor *tensor, GArrowTensor *other_tensor); gboolean
garrow_tensor_get_value_data_type(GArrowTensor *tensor); GArrowDataType *
garrow_tensor_get_value_type(GArrowTensor *tensor); GArrowType
garrow_tensor_get_buffer(GArrowTensor *tensor); GArrowBuffer *
garrow_tensor_get_shape(GArrowTensor *tensor, gint *n_dimensions); gint64 *
garrow_tensor_get_strides(GArrowTensor *tensor, gint *n_strides); gint64 *
garrow_tensor_get_n_dimensions(GArrowTensor *tensor); gint
garrow_tensor_get_dimension_name(GArrowTensor *tensor, gint i); const gchar *
garrow_tensor_get_size(GArrowTensor *tensor); gint64
garrow_tensor_is_mutable(GArrowTensor *tensor); gboolean
garrow_tensor_is_contiguous(GArrowTensor *tensor); gboolean
garrow_tensor_is_row_major(GArrowTensor *tensor); gboolean
garrow_tensor_is_column_major(GArrowTensor *tensor); gboolean
garrow_tensor_new_raw(std::shared_ptr<arrow::Tensor> *arrow_tensor); ArrowTensor *
garrow_tensor_new_raw_buffer(std::shared_ptr<arrow::Tensor> *arrow_tensor, GArrowBuffer *buffer); GArrowTensor *
garrow_tensor_get_raw(GArrowTensor *tensor); std::shared_ptr<arrow::Tensor>
)
NB. =========================================================
NB. Decimal
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/decimal.html
NB. =========================================================

decimalBindings =: lib 0 : 0
ADD TYPES
garrow_decimal_new_string(const gchar *data); garrowType *
garrow_decimal_new_integer(const gint64 data); garrowType *
garrow_decimal_copy(typename DecimalConverter<Decimal>, garrowType *decimal); garrowType *
garrow_decimal_equal(typename DecimalConverter<Decimal>, garrowType *decimal, typename DecimalConverter<Decimal>:, garrowType *other_decimal); gboolean
garrow_decimal_not_equal(typename DecimalConverter<Decimal>:,garrowType *decimal, typename DecimalConverter<Decimal>:,garrowType *other_decimal); gboolean
garrow_decimal_less_than(typename DecimalConverter<Decimal>:,garrowType *decimal, typename DecimalConverter<Decimal>:,garrowType *other_decimal); gboolean
garrow_decimal_less_than_or_equal(typename DecimalConverter<Decimal>:,garrowType *decimal , typename DecimalConverter<Decimal>:,garrowType *other_decimal); gboolean
garrow_decimal_greater_than(typename DecimalConverter<Decimal>:,garrowType *decimal, typename DecimalConverter<Decimal>:,garrowType *other_decimal); gboolean
garrow_decimal_greater_than_or_equal(typename DecimalConverter<Decimal>:,garrowType *decimal, typename DecimalConverter<Decimal>:,garrowType *other_decimal); gboolean
garrow_decimal_to_string_scale(typename DecimalConverter<Decimal>:,garrowType *decimal, gint32 scale); gchar *
garrow_decimal_to_string(typename DecimalConverter<Decimal>:,garrowType *decimal); gchar *
garrow_decimal_to_bytes(typename DecimalConverter<Decimal>:,garrowType *decimal); GBytes *
garrow_decimal_abs(typename DecimalConverter<Decimal>:,garrowType *decimal); void
garrow_decimal_negate(typename DecimalConverter<Decimal>:,garrowType *decimal); void
garrow_decimal_plus(typename DecimalConverter<Decimal>:,garrowType *left, typename DecimalConverter<Decimal>:; garrowType *
garrow_decimal_minus(typename DecimalConverter<Decimal>:,garrowType *left, typename DecimalConverter<Decimal>:; garrowType *
garrow_decimal_multiply(typename DecimalConverter<Decimal>:,garrowType *left, typename DecimalConverter<Decimal>:; garrowType *
garrow_decimal_divide(typename DecimalConverter<Decimal>:,garrowType *left, typename DecimalConverter<Decimal>:; garrowType *
garrow_decimal_rescale(typename DecimalConverter<Decimal>:,garrowType *decimal, gint32 original_scale, gint32 new_scale, GError **error, const gchar *tag); garrowType *
garrow_decimal128_finalize(GObject *object); static void
garrow_decimal128_set_property(GObject *object, guint prop_id, const GValue *value, GParamSpec *pspec); static void
garrow_decimal128_init(GArrowDecimal128 *object); static void
garrow_decimal128_class_init(GArrowDecimal128Class *klass); static void
garrow_decimal128_new_string(const gchar *data); GArrowDecimal128 *
garrow_decimal128_new_integer(const gint64 data); GArrowDecimal128 *
garrow_decimal128_copy(GArrowDecimal128 *decimal); GArrowDecimal128 *
garrow_decimal128_equal(GArrowDecimal128 *decimal, GArrowDecimal128 *other_decimal); gboolean
garrow_decimal128_not_equal(GArrowDecimal128 *decimal, GArrowDecimal128 *other_decimal); gboolean
garrow_decimal128_less_than(GArrowDecimal128 *decimal, GArrowDecimal128 *other_decimal); gboolean
garrow_decimal128_less_than_or_equal(GArrowDecimal128 *decimal, GArrowDecimal128 *other_decimal); gboolean
garrow_decimal128_greater_than(GArrowDecimal128 *decimal, GArrowDecimal128 *other_decimal); gboolean
garrow_decimal128_greater_than_or_equal(GArrowDecimal128 *decimal, GArrowDecimal128 *other_decimal); gboolean
garrow_decimal128_to_string_scale(GArrowDecimal128 *decimal, gint32 scale); gchar *
garrow_decimal128_to_string(GArrowDecimal128 *decimal); gchar *
garrow_decimal128_to_bytes(GArrowDecimal128 *decimal); GBytes *
garrow_decimal128_abs(GArrowDecimal128 *decimal); void
garrow_decimal128_negate(GArrowDecimal128 *decimal); void
garrow_decimal128_to_integer(GArrowDecimal128 *decimal); gint64
garrow_decimal128_plus(GArrowDecimal128 *left, GArrowDecimal128 *right); GArrowDecimal128 *
garrow_decimal128_minus(GArrowDecimal128 *left, GArrowDecimal128 *right); GArrowDecimal128 *
garrow_decimal128_multiply(GArrowDecimal128 *left, GArrowDecimal128 *right); GArrowDecimal128 *
garrow_decimal128_divide(GArrowDecimal128 *left, GArrowDecimal128 *right, GArrowDecimal128 **remainder, GError **error); GArrowDecimal128 *
garrow_decimal128_rescale(GArrowDecimal128 *decimal, gint32 original_scale, gint32 new_scale, GError **error); GArrowDecimal128 *
garrow_decimal256_finalize(GObject *object); static void
garrow_decimal256_set_property(GObject *object, guint prop_id, const GValue *value, GParamSpec *pspec); static void
garrow_decimal256_init(GArrowDecimal256 *object); static void
garrow_decimal256_class_init(GArrowDecimal256Class *klass); static void
garrow_decimal256_new_string(const gchar *data); GArrowDecimal256 *
garrow_decimal256_new_integer(const gint64 data); GArrowDecimal256 *
garrow_decimal256_copy(GArrowDecimal256 *decimal); GArrowDecimal256 *
garrow_decimal256_equal(GArrowDecimal256 *decimal, GArrowDecimal256 *other_decimal); gboolean
garrow_decimal256_not_equal(GArrowDecimal256 *decimal, GArrowDecimal256 *other_decimal); gboolean
garrow_decimal256_less_than(GArrowDecimal256 *decimal, GArrowDecimal256 *other_decimal); gboolean
garrow_decimal256_less_than_or_equal(GArrowDecimal256 *decimal, GArrowDecimal256 *other_decimal); gboolean
garrow_decimal256_greater_than(GArrowDecimal256 *decimal, GArrowDecimal256 *other_decimal); gboolean
garrow_decimal256_greater_than_or_equal(GArrowDecimal256 *decimal, GArrowDecimal256 *other_decimal); gboolean
garrow_decimal256_to_string_scale(GArrowDecimal256 *decimal, gint32 scale); gchar *
garrow_decimal256_to_string(GArrowDecimal256 *decimal); gchar *
garrow_decimal256_to_bytes(GArrowDecimal256 *decimal); GBytes *
garrow_decimal256_abs(GArrowDecimal256 *decimal); void
garrow_decimal256_negate(GArrowDecimal256 *decimal); void
garrow_decimal256_plus(GArrowDecimal256 *left, GArrowDecimal256 *right); GArrowDecimal256 *
garrow_decimal256_multiply(GArrowDecimal256 *left, GArrowDecimal256 *right); GArrowDecimal256 *
garrow_decimal256_divide(GArrowDecimal256 *left, GArrowDecimal256 *right, GArrowDecimal256 **remainder, GError **error); GArrowDecimal256 *
garrow_decimal256_rescale(GArrowDecimal256 *decimal, gint32 original_scale, gint32 new_scale, GError **error); GArrowDecimal256 *
garrow_decimal128_new_raw(std::shared_ptr<arrow::Decimal128> *arrow_decimal128); ArrowDecimal128 *
garrow_decimal128_get_raw(GArrowDecimal128 *decimal128); std::shared_ptr<arrow::Decimal128>
garrow_decimal256_new_raw(std::shared_ptr<arrow::Decimal256> *arrow_decimal256); GArrowDecimal256 *
garrow_decimal256_get_raw(GArrowDecimal256 *decimal256); std::shared_ptr<arrow::Decimal256>
)
NB. =========================================================
NB. GObject bindings
NB. 
NB. =========================================================

gLibBindings =: lib 0 : 0 
* i	g_malloc	(gsize n_bytes); 	pointer
n *	g_free	(gpointer mem) void
* & i	g_bytes_new	(gconstpointer data,  gsize size);	GBytes*
* & i	g_bytes_new_static	(gconstpointer data, gsize size);	GBytes*
* & i	g_bytes_new_take	(gconstpointer data, gsize size);	GBytes*
i *	g_bytes_get_size	(GBytes* bytes);	gsize
* * *	g_bytes_get_data	(GBytes* bytes, gsize* size); gconstpointer
* * *	g_bytes_unref_to_data	(GBytes* bytes, gsize* size); gpointer
* *	g_bytes_unref_to_array	(GBytes* bytes); GByteArray*
n *	g_bytes_unref 	(GBytes* bytes); 	void
n * * * *	g_object_get	(GObject* object, const gchar* first_property_name, *first_value, NULL); void
n * * b *	g_object_set	(GObject* object, const gchar* first_property_name, *first_value, NULL); void
n * 	g_object_unref	(GObject* object); void
n *	g_clear_object	(GObject** object_ptr);	void
*	g_list_alloc	(void) GList*
* * *	g_list_append	(GList* list, gpointer data) GList*
n * 	g_list_free	(GList* list) void
i *	g_list_length	(GList* list) guint
* * i	g_list_nth_data	(GList* list, guint n);	gpointer
* *	g_type_name	(GType type);	gchar *
* *	g_type_class_peek	( GType type);	GObjectTypeClass*
* *	g_param_spec_get_name	(GParamSpec* pspec)	const gchar*
* * *	g_object_class_find_property	( GObjectClass* oclass,  const gchar* property_name)	GParamSpec*
* *	g_type_create_instance	(GType type)	GTypeInstance*
* * * *	g_filename_to_uri	(const gchar* filename,  const gchar* hostname,  GError** error) gchar*
n *	g_error_free	(GError* error);	void
)


NB. IO

NB. Input
NB. GArrowReadable — Input interface
NB. =========================================================
NB. Readable
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/GArrowReadable.html
NB. =========================================================
readableBindings =: lib 0 : 0
* * l *	garrow_readable_read	(GArrowReadable *readable, gint64 n_bytes, GError **error); GArrowBuffer *
* * l *	garrow_readable_read_bytes	(GArrowReadable *readable, gint64 n_bytes, GError **error); GBytes *
)

NB. Input stream classes
NB. =========================================================	
NB. Input Stream	
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/input-stream-classes.html
NB. =========================================================
inputStreamBindings =: lib 0 : 0
i * l *	garrow_input_stream_advance	(GArrowInputStream *input_stream, gint64 n_bytes, GError **error); gboolean
i * i *	garrow_input_stream_align	(GArrowInputStream *input_stream, gint32 alignment, GError **error); gboolean
* * *	garrow_input_stream_read_tensor	(GArrowInputStream *input_stream, GError **error); GArrowTensor *
* * * * *	garrow_input_stream_read_record_batch	(GArrowInputStream *input_stream, GArrowSchema *schema, GArrowReadOptions *options, GError **error); GArrowRecordBatch *
i * *	garrow_seekable_input_stream_get_size	(GArrowSeekableInputStream *input_stream, GError **error); guint64
i *	garrow_seekable_input_stream_get_support_zero_copy	(GArrowSeekableInputStream *input_stream); gboolean
* * l l *	garrow_seekable_input_stream_read_at	(GArrowSeekableInputStream *input_stream, gint64 position, gint64 n_bytes, GError **error); GArrowBuffer *
* * l l *	garrow_seekable_input_stream_read_at_bytes	(GArrowSeekableInputStream *input_stream, gint64 position, gint64 n_bytes, GError **error); GBytes *
* * l *	garrow_seekable_input_stream_peek	(GArrowSeekableInputStream *input_stream , gint64 n_bytes , GError **error); GBytes *
* * *	garrow_file_input_stream_new	(const gchar *path, GError **error); GArrowFileInputStream *
* i *	garrow_file_input_stream_new_file_descriptor	(gint file_descriptor, GError **error); GArrowFileInputStream *
i * *	garrow_file_input_stream_get_file_descriptor	(const gchar *path, GError **error); gint
* *	garrow_buffer_input_stream_new	(GArrowBuffer *buffer); GArrowBufferInputStream *
* *	garrow_buffer_input_stream_get_buffer	(GArrowBufferInputStream *input_stream); GArrowBuffer *
* * *	garrow_memory_mapped_input_stream_new	(const gchar *path, GError **error); GArrowMemoryMappedInputStream *
* *	garrow_gio_input_stream_new	(GInputStream *gio_input_stream); GArrowGIOInputStream *
* *	garrow_gio_input_stream_get_raw	(GArrowGIOInputStream *input_stream); GInputStream *
* * * *	garrow_compressed_input_stream_new	(GArrowCodec *codec, GArrowInputStream *raw, GError **error); GArrowCompressedInputStream *
)

NB. Output
NB. GArrowWritable — Output interface
NB. =========================================================
NB. Writeable
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/GArrowWritable.html
NB. =========================================================
writeableBindings =: lib 0 : 0
n *	garrow_writable_default_init	(GArrowWritableInterface *iface); static void
b * * l *	garrow_writable_write	(GArrowWritable *writable, const guint8 *data, gint64 n_bytes, GError **error); gboolean
b *	garrow_writable_flush	(GArrowWritable *writable, GError **error); gboolean
* *	garrow_writable_get_raw	(GArrowWritable *writable); std::shared_ptr<arrow::io::Writable>
)

NB. GArrowWritableFile — File output interface
NB. =========================================================
NB. Writeable File
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/GArrowWritableFile.html
NB. =========================================================
writeableFileBindings =: lib 0 : 0
n *	garrow_writable_file_default_init	(GArrowWritableFileInterface *iface); static void
i * l i i *	garrow_writable_file_write_at	(GArrowWritableFile *writable_file, gint64 position, const guint8 *data, gint64 n_bytes, GError **error); gboolean
* *	garrow_writable_file_get_raw	(GArrowWritableFile *writable_file); std::shared_ptr<arrow::io::WritableFile>
)

NB. Output stream classes
NB. =========================================================
NB. Output Stream
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/output-stream-classes.html
NB. =========================================================
outputStreamBindings =: lib 0 : 0
i * i *	garrow_output_stream_align	(GArrowOutputStream *stream, gint32 alignment, GError **error); gboolean
i * * *	garrow_output_stream_write_tensor	(GArrowOutputStream *stream , GArrowTensor *tensor , GError **error); gint64
i * * * *	garrow_output_stream_write_record_batch	(GArrowOutputStream *stream, GArrowRecordBatch *record_batch, GArrowWriteOptions *options, GError **error); gint64
* *c b *	garrow_file_output_stream_new	(const gchar *path, gboolean append, GError **error); GArrowFileOutputStream *
* *	garrow_buffer_output_stream_new	(GArrowResizableBuffer *buffer); GArrowBufferOutputStream *
* *	garrow_gio_output_stream_new	(GOutputStream *gio_output_stream); GArrowGIOOutputStream *
* *	garrow_gio_output_stream_get_raw	(GArrowGIOOutputStream *output_stream); GOutputStream *
)

NB. Input and output

NB. GArrowFile — File interface
NB. =========================================================
NB. File
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/GArrowFile.html
NB. =========================================================
fileBindings =: lib 0 : 0
i * *	garrow_file_close	(GArrowFile *file, GError **error); gboolean
i *	garrow_file_is_closed	(GArrowFile *file); gboolean
l *	garrow_file_tell	(GArrowFile *file, GError **error); gint64
* *	garrow_file_get_mode	(GArrowFile *file); GArrowFileMode
)
NB. IPC
NB. Options
NB. IPC options classes
NB. =========================================================
NB. IPC Options
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/ipc-options-classes.html
NB. =========================================================
ipcOptionsBindings =: lib 0 : 0
*	garrow_read_options_new	(void); GArrowReadOptions *
*i * *	garrow_read_options_get_included_fields	(GArrowReadOptions *options, gsize *n_fields); int *
n * * i	garrow_read_options_set_included_fields	(GArrowReadOptions *options, int *fields, gsize n_fields); void
*	garrow_write_options_new	(void); GArrowWriteOptions *
)

NB. Reader
NB. Reader classes
NB. =========================================================
NB. Reader
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/reader-classes.html
NB. =========================================================
readerBindings =: lib 0 : 0
* * *	garrow_record_batch_reader_import	(gpointer c_abi_array_stream, GError **error);GArrowRecordBatchReader *
* * * *	garrow_record_batch_reader_new	(GList *record_batches, GArrowSchema *schema, GError **error);GArrowRecordBatchReader *);GArrowRecordBatchReader *
* * *	garrow_record_batch_reader_export	(GArrowRecordBatchReader *reader, GError **error);gpointer
* *	garrow_record_batch_reader_get_schema	(GArrowRecordBatchReader *reader); GArrowSchema *
* * *	garrow_record_batch_reader_read_next	(GArrowRecordBatchReader *reader, GError **error); GArrowRecordBatch *
* * *	garrow_record_batch_reader_read_all	(GArrowRecordBatchReader *reader, GError **error); GArrowTable *
* *	garrow_table_batch_reader_new	(GArrowTable *table); GArrowTableBatchReader *
* * *	garrow_record_batch_stream_reader_new	(GArrowInputStream *stream, GError **error); GArrowRecordBatchStreamReader *
* * *	garrow_record_batch_file_reader_new	(GArrowSeekableInputStream *file, GError **error); GArrowRecordBatchFileReader *
* *	garrow_record_batch_file_reader_get_schema	(GArrowRecordBatchFileReader *reader); GArrowSchema *
i *	garrow_record_batch_file_reader_get_n_record_batches	(GArrowRecordBatchFileReader *reader); guint
i *	garrow_record_batch_file_reader_get_version	(GArrowRecordBatchFileReader *reader); GArrowMetadataVersion
* * i *	garrow_record_batch_file_reader_get_record_batch	(GArrowRecordBatchFileReader *reader, guint i, GError **error); GArrowRecordBatch *
* * i *	garrow_record_batch_file_reader_read_record_batch	(GArrowRecordBatchFileReader *reader, guint i, GError **error); GArrowRecordBatch *
* * *	garrow_feather_file_reader_new	(GArrowSeekableInputStream *file, GError **error); GArrowFeatherFileReader *
i *	garrow_feather_file_reader_get_version	(GArrowFeatherFileReader *reader); gint
* * *	garrow_feather_file_reader_read	(GArrowFeatherFileReader *reader, GError **error); GArrowTable *
* * * i *	garrow_feather_file_reader_read_indices	(GArrowFeatherFileReader *reader, const gint *indices, guint n_indices, GError **error); GArrowTable *
* * * i *	garrow_feather_file_reader_read_names	(GArrowFeatherFileReader *reader, const gchar **names, guint n_names, GError **error); GArrowTable *
*	garrow_csv_read_options_new	(void); GArrowCSVReadOptions *
n * * *	garrow_csv_read_options_add_column_type	(GArrowCSVReadOptions *options, const gchar *name, GArrowDataType *data_type); void
n * *	garrow_csv_read_options_add_schema	(GArrowCSVReadOptions *options, GArrowSchema *schema); void
* *	garrow_csv_read_options_get_column_types	(GArrowCSVReadOptions *options); GHashTable *
n * * i	garrow_csv_read_options_set_null_values	(GArrowCSVReadOptions *options, const gchar **null_values, gsize n_null_values); void
* *	garrow_csv_read_options_get_null_values	(GArrowCSVReadOptions *options); gchar **
n * *	garrow_csv_read_options_add_null_value	(GArrowCSVReadOptions *options, const gchar *null_value); void
n * i	garrow_csv_read_options_set_true_values	(GArrowCSVReadOptions *options, const gchar **true_values, gsize n_true_values); void
* *	garrow_csv_read_options_get_true_values	(GArrowCSVReadOptions *options); gchar **
n *	garrow_csv_read_options_add_true_value	(GArrowCSVReadOptions *options, const gchar *true_value); void
n * * u	garrow_csv_read_options_set_false_values	(GArrowCSVReadOptions *options, const gchar **false_values, gsize n_false_values); void
* *	garrow_csv_read_options_get_false_values	(GArrowCSVReadOptions *options); gchar **
n * *	garrow_csv_read_options_add_false_value	(GArrowCSVReadOptions *options, const gchar *false_value); void
n * * i	garrow_csv_read_options_set_column_names	(GArrowCSVReadOptions *options, const gchar **column_names, gsize n_column_names); void
* *	garrow_csv_read_options_get_column_names	(GArrowCSVReadOptions *options); gchar **
n * *	garrow_csv_read_options_add_column_name	(GArrowCSVReadOptions *options, const gchar *column_name); void
* * * *	garrow_csv_reader_new	(GArrowInputStream *input, GArrowCSVReadOptions *options, GError **error); GArrowCSVReader *
* * *	garrow_csv_reader_read	(GArrowCSVReader *reader, GError **error); GArrowTable *
*	garrow_json_read_options_new	(void); GArrowJSONReadOptions *
* * * *	garrow_json_reader_new	(GArrowInputStream *input, GArrowJSONReadOptions *options, GError **error); GArrowJSONReader *
* * *	garrow_json_reader_read	(GArrowJSONReader *reader, GError **error); GArrowTable *
)

NB. ORC reader
NB. =========================================================
NB. ORC File Reader
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/orc-file-reader.html
NB. =========================================================
orcFileReaderBindings =: lib 0 : 0
* * * i	garrow_orc_file_reader_new	(GArrowSeekableInputStream *input, GError **error); GArrowORCFileReader *
n * * i	garrow_orc_file_reader_set_field_indexes	(GArrowORCFileReader *reader, const gint *field_indexes, guint n_field_indexes); void
n * *i	garrow_orc_file_reader_set_field_indices	(GArrowORCFileReader *reader, const gint *field_indices, guint n_field_indices); void
*i * *i	garrow_orc_file_reader_get_field_indexes	(GArrowORCFileReader *reader, guint *n_field_indexes); const gint *
*i * *i	garrow_orc_file_reader_get_field_indices	(GArrowORCFileReader *reader, guint *n_field_indices); const gint *
* * *	garrow_orc_file_reader_read_type	(GArrowORCFileReader *reader , GError **error); GArrowSchema *
* * *	garrow_orc_file_reader_read_stripes	(GArrowORCFileReader *reader, GError **error); GArrowTable *
* * x *	garrow_orc_file_reader_read_stripe	(GArrowORCFileReader *reader, gint64 i, GError **error); GArrowRecordBatch *
x *	garrow_orc_file_reader_get_n_stripes	(GArrowORCFileReader *reader); gint64
x *	garrow_orc_file_reader_get_n_rows	(GArrowORCFileReader *reader); gint64
)
NB. Writer
NB. Writer classes

NB. =========================================================
NB. Writer
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/writer-classes.html
NB. =========================================================
writerBindings =: lib 0 : 0
i * * *	garrow_record_batch_writer_write_record_batch	(GArrowRecordBatchWriter *writer, GArrowRecordBatch *record_batch, GError **error); gboolean
i * * *	garrow_record_batch_writer_write_table	(GArrowRecordBatchWriter *writer, GArrowTable *table, GError **error); gboolean
i * *	garrow_record_batch_writer_close	(GArrowRecordBatchWriter *writer , GError **error); gboolean
* * * *	garrow_record_batch_stream_writer_new	(GArrowOutputStream *sink, GArrowSchema *schema, GError **error); GArrowRecordBatchStreamWriter *
* * * *	garrow_record_batch_file_writer_new	(GArrowOutputStream *sink, GArrowSchema *schema, GError **error); GArrowRecordBatchFileWriter *
)
NB. =========================================================
NB. File System
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/file-system-classes.html
NB. =========================================================

fileSystemBindings =: lib 0 : 0
*	garrow_file_info_new	(void); GArrowFileInfo *
b * *	garrow_file_info_equal	(GArrowFileInfo *file_info, GArrowFileInfo *other_file_info); gboolean
b *	garrow_file_info_is_file	(GArrowFileInfo *file_info); gboolean
b *	garrow_file_info_is_dir	(GArrowFileInfo *file_info); gboolean
* *	garrow_file_info_to_string	(GArrowFileInfo *file_info); gchar *
* * *	garrow_file_system_create	(const gchar *uri, GError **error); GArrowFileSystem *
* *	garrow_file_system_get_type_name	(GArrowFileSystem *file_system); gchar *
* * * *	garrow_file_system_get_file_info	(GArrowFileSystem *file_system , const gchar *path , GError **error); GArrowFileInfo *
* * * i *	garrow_file_system_get_file_infos_paths	(GArrowFileSystem *file_system, const gchar **paths, gsize n_paths, GError **error); GList *
* * * *	garrow_file_system_get_file_infos_selector	(GArrowFileSystem *file_system, GArrowFileSelector *file_selector, GError **error); GList *
b * * b *	garrow_file_system_create_dir	(GArrowFileSystem *file_system, const gchar *path, gboolean recursive, GError **error); gboolean
b * * *	garrow_file_system_delete_dir	(GArrowFileSystem *file_system, const gchar *path, GError **error); gboolean
b * * *	garrow_file_system_delete_dir_contents	(GArrowFileSystem *file_system, const gchar *path, GError **error); gboolean
b * * *	garrow_file_system_delete_file	(GArrowFileSystem *file_system, const gchar *path, GError **error); gboolean
b * * i *	garrow_file_system_delete_files	(GArrowFileSystem *file_system, const gchar **paths, gsize n_paths, GError **error); gboolean
b * * * *	garrow_file_system_move	(GArrowFileSystem *file_system, const gchar *src, const gchar *dest, GError **error); gboolean
b * * * *	garrow_file_system_copy_file	(GArrowFileSystem *file_system, const gchar *src, const gchar *dest, GError **error); gboolean
* * * *	garrow_file_system_open_input_stream	(GArrowFileSystem *file_system, const gchar *path, GError **error); GArrowInputStream *
* * * *	garrow_file_system_open_input_file	(GArrowFileSystem *file_system, const gchar *path, GError **error); GArrowSeekableInputStream *
* * * *	garrow_file_system_open_output_stream	(GArrowFileSystem *file_system, const gchar *path, GError **error); GArrowOutputStream *
* * * *	garrow_file_system_open_append_stream	(GArrowFileSystem *file_system, const gchar *path, GError **error); GArrowOutputStream *
n *	garrow_sub_tree_file_system_dispose	(GObject *object); static void
* * *	garrow_sub_tree_file_system_new	(const gchar *base_path, GArrowFileSystem *base_file_system); GArrowSubTreeFileSystem *
* * l	garrow_slow_file_system_new_average_latency	(GArrowFileSystem *base_file_system, gdouble average_latency); GArrowSlowFileSystem *
* * l i	garrow_slow_file_system_new_average_latency_and_seed	(GArrowFileSystem *base_file_system, gdouble average_latency, gint32 seed); GArrowSlowFileSystem *
)

NB. =========================================================
NB. Local File System	
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/local-file-system-classes.html
NB. =========================================================

localFileSystemBindings =: lib 0 : 0
*	garrow_local_file_system_options_new	(void); GArrowLocalFileSystemOptions *	
n *	garrow_local_file_system_init	(GArrowLocalFileSystem *file_system); static void
* *	garrow_local_file_system_new	(GArrowLocalFileSystemOptions *options); GArrowLocalFileSystem *
)
NB. Memory
NB. =========================================================
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/memory-pool-classes.html#garrow-memory-pool-default
NB. =========================================================

memoryBindings =: lib 0 : 0
*	garrow_memory_pool_default	(); GArrowMemoryPool *
l *	garrow_memory_pool_get_bytes_allocated	(GArrowMemoryPool *memory_pool); gint64
l *	garrow_memory_pool_get_max_memory 	(GArrowMemoryPool *memory_pool); gint64
*c *	garrow_memory_pool_get_backend_name 	(GArrowMemoryPool *memory_pool); gchar *
)
NB. =========================================================
NB. Commmon
NB. https://github.com/apache/arrow/blob/master/c_glib/arrow-flight-glib
NB. =========================================================

commonFlightBindings =: lib 0 : 0
* *	gaflight_descriptor_to_string	(GAFlightDescriptor *descriptor); gchar *
* *	gaflight_criteria_new	(GBytes *expression); GAFlightCriteria *
*	gaflight_criteria_get_type
* * *	gaflight_location_new	(const gchar *uri, GError **error); GAFlightLocation *
* *	gaflight_location_to_string	(GAFlightLocation *location); gchar *
* *	gaflight_location_get_scheme	(GAFlightLocation *location); gchar *
b * *	gaflight_location_equal	(GAFlightLocation *location, GAFlightLocation *other_location); gboolean
*	gaflight_location_get_type
b * *	gaflight_descriptor_equal	(GAFlightDescriptor *descriptor, GAFlightDescriptor *other_descriptor) gboolean
*	gaflight_descriptor_get_type
* * i	gaflight_path_descriptor_new	(const gchar **paths, gsize n_paths); GAFlightPathDescriptor *
* *	gaflight_path_descriptor_get_paths 	(GAFlightPathDescriptor *descriptor); gchar **
*	gaflight_path_descriptor_get_type
* *	gaflight_command_descriptor_new	(const gchar *command); GAFlightCommandDescriptor *
* *	gaflight_command_descriptor_get_command	(GAFlightCommandDescriptor *descriptor); gchar *
* *	gaflight_ticket_new	(GBytes *data); GAFlightTicket *
b * *	gaflight_ticket_equal	(GAFlightTicket *ticket, GAFlightTicket *other_ticket); gboolean
* 	gaflight_ticket_get_type	
* * *	gaflight_endpoint_new	(GAFlightTicket *ticket, GList *locations); GAFlightEndpoint *
b * *	gaflight_endpoint_equal	(GAFlightEndpoint *endpoint, GAFlightEndpoint *other_endpoint); gboolean
* *	gaflight_endpoint_get_locations	(GAFlightEndpoint *endpoint); GList *
*	gaflight_endpoint_get_type
* * * i i *	gaflight_info_new	(GArrowSchema *schema, GAFlightDescriptor *descriptor, GList *endpoints, gint64 total_records, gint64 total_bytes, GError **error); GAFlightInfo *
b * *	gaflight_info_equal	(GAFlightInfo *info, GAFlightInfo *other_info); gboolean
* * * *	gaflight_info_get_schema	(GAFlightInfo *info, GArrowReadOptions *options, GError **error); GArrowSchema *
* *	gaflight_info_get_descriptor	(GAFlightInfo *info); GAFlightDescriptor *
* *	gaflight_info_get_endpoints	(GAFlightInfo *info); GList *
i *	gaflight_info_get_total_records	(GAFlightInfo *info); gint64
i *	gaflight_info_get_total_bytes	(GAFlightInfo *info); gint64
*	gaflight_info_get_type
* *	gaflight_stream_chunk_get_data	(GAFlightStreamChunk *chunk); GArrowRecordBatch *
* *	gaflight_stream_chunk_get_metadata	(GAFlightStreamChunk *chunk); GArrowBuffer *
*	gaflight_stream_chunk_get_type
* * *	gaflight_record_batch_reader_read_next	(GAFlightRecordBatchReader *reader, GError **error); GAFlightStreamChunk *
* * *	gaflight_record_batch_reader_read_all	(GAFlightRecordBatchReader *reader, GError **error); GArrowTable *
)

NB. =========================================================
NB. Client
NB. https://github.com/apache/arrow/blob/master/c_glib/arrow-flight-glib
NB. =========================================================
clientFlightBindings =: lib 0 : 0
*	gaflight_call_options_new	(void); GAFlightCallOptions *
n * * *	gaflight_call_options_add_header	(GAFlightCallOptions *options, const gchar *name, const gchar *value); void
n *	gaflight_call_options_clear_headers	(GAFlightCallOptions *options); void
n * * *	gaflight_call_options_foreach_header	(GAFlightCallOptions *options, GAFlightHeaderFunc func, gpointer user_data); void
*	gaflight_call_options_get_type
*	gaflight_client_options_new	(void); GAFlightClientOptions *
*	gaflight_client_options_get_type
* * * *	gaflight_client_new	(GAFlightLocation *location, GAFlightClientOptions *options, GError **error); GAFlightClient *
* * * * *	gaflight_client_list_flights	(GAFlightClient *client, GAFlightCriteria *criteria, GAFlightCallOptions *options, GError **error); GList *
b * *	gaflight_client_close	(GAFlightClient *client, GError **error); gboolean
* * * * *	gaflight_client_get_flight_info	(GAFlightClient *client, GAFlightDescriptor *descriptor, GAFlightCallOptions *options, GError **error); GAFlightInfo *
* * * * *	gaflight_client_do_get	(GAFlightClient *client, GAFlightTicket *ticket, GAFlightCallOptions *options, GError **error); GAFlightStreamReader *
*	gaflight_client_get_type
*	gaflight_stream_reader_get_type
)


NB. =========================================================
NB. Server
NB. https://github.com/apache/arrow/blob/master/c_glib/arrow-flight-glib
NB. =========================================================
serverFlightBindings =: lib 0 : 0
* *	gaflight_record_batch_stream_new	(GArrowRecordBatchReader *reader); GAFlightRecordBatchStream *
* *	gaflight_server_options_new	(GAFlightLocation *location); GAFlightServerOptions *
b * * *	gaflight_server_listen	(GAFlightServer *server, GAFlightServerOptions *options, GError **error); gboolean 
i *	gaflight_server_get_port	(GAFlightServer *server); gint 
i * *	gaflight_server_shutdown	(GAFlightServer *server, GError **error); gboolean 
i * *	gaflight_server_wait	(GAFlightServer *server, GError **error); gboolean 
* * * * *	gaflight_server_list_flights	(GAFlightServer *server, GAFlightServerCallContext *context, GAFlightCriteria *criteria, GError **error); GList *
* * * * *	gaflight_server_get_flight_info	(GAFlightServer *server, GAFlightServerCallContext *context, GAFlightDescriptor *request, GError **error); GAFlightInfo *
* * * * *	gaflight_server_do_get	(GAFlightServer *server, GAFlightServerCallContext *context, GAFlightTicket *ticket, GError **error); GAFlightDataStream *
)
NB. =========================================================
NB. Type
NB. =========================================================

NB. Definition of NULL value replacement for read files.
NULL=: __

garrow_na_array_get_valueSHIM=: NULL&[

garrow_na_array_get_valuesSHIM=: {{(1 getInts > {: y) # NULL}}

NB. garrow_string_array_get_stringSHIM =: <@getString@>@{.@garrow_string_array_get_string
garrow_string_array_get_stringSHIM=: <@<@getStringFree@{.@garrow_string_array_get_string
garrow_boolean_array_get_valueSHIM=: (3&u:)@(7&u:)@>@{.@garrow_boolean_array_get_value

getBufferData=: {{
bufferPtr=. y
NB. cap =. ret garrow_buffer_get_capacity < bufferPtr
NB. val =. ret garrow_buffer_get_size < bufferPtr
gbPtr=. ptr garrow_buffer_get_data < bufferPtr
gbsize=. ret g_bytes_get_size < gbPtr
dataPtr=. ptr g_bytes_get_data gbPtr; < pt=. setInts gbsize
NB. g_bytes_unref < gbPtr
NB. dataPtr=. ptr g_bytes_unref_to_data gbPtr; < pt=. setInts gbsize
memf > pt
dataPtr
}}

setBufferData=: {{
dataPtr =. y
ptr garrow_buffer_new_bytes < dataPtr
}}

NB. Read variable length strings directly from buffer.
garrow_string_array_get_stringsSHIM=: {{
'arrayPt'=. > {. y
bufferPtr =. ptr garrow_binary_array_get_data_buffer < arrayPt NB. Two pointers for binary arrays: 1) data and 2) offsets
dataPtr=. getBufferData bufferPtr
offsetPtr=. getBufferData ptr garrow_binary_array_get_offsets_buffer < arrayPt
locLen=. (4&*)@>: ret garrow_array_get_length < arrayPt
loc=. _2&(3!:4) memr (>offsetPtr),0,locLen,2
dat=. getString dataPtr
res=. ((0&|:)@,:@(}:,.(}.-}:)) loc) <;.0 dat
removeObject"0 bufferPtr
NB. g_bytes_unref < dataPtr
res
}}

byteSHIM=: {{
'arrayPt lengthPtr'=. y
resPtr=. ptr v arrayPt;<lengthPtr
length =. 1 getInts lengthPtr
bitWidth=. ret garrow_fixed_width_data_type_get_bit_width < ptr garrow_array_get_value_data_type <arrayPt
bytes=. memr (>resPtr),0,(length * bitWidth <.@% 8),2
res=. u bytes
res
}}

garrow_uint16_array_get_valuesSHIM=: (_1&ic byteSHIM garrow_uint16_array_get_values)
garrow_int16_array_get_valuesSHIM=: (_1&ic byteSHIM garrow_int16_array_get_values)
garrow_uint32_array_get_valuesSHIM=: (_2&ic byteSHIM garrow_uint32_array_get_values)
garrow_int32_array_get_valuesSHIM=: (_2&ic byteSHIM garrow_int32_array_get_values)
garrow_float_array_get_valuesSHIM=: (_1&fc byteSHIM garrow_float_array_get_values)
garrow_date32_array_get_valuesSHIM=: (_2&ic byteSHIM garrow_date32_array_get_values)
garrow_time32_array_get_valuesSHIM=: (_2&ic byteSHIM garrow_time32_array_get_values)

garrow_dictionary_array_get_indicesSHIM=: {{
indicesArrayPtr =. ptr@garrow_dictionary_array_get_indices@{. y
res =. readArray indicesArrayPtr
removeObject indicesArrayPtr
res
}}

NB. or use garrow_dictionary_array_get_dictionary for values

deTAB =. #~ ((+.) (1: |. (> </\)))@(TAB&~:)

'typeGArrowName typeName typeGetValue typeGetValues typeNew typeJ typeJMemr typeDescription' =: (<"1)@|:@(>@(((9{a.)&cut)&.>)@}.@((10{a.)&cut))@deTAB 0 : 0
GARROW_TYP			name		getValue				getValues				typeNew			typeJMemrJtype	Jmemr	description
GARROW_TYPE_NA		null		garrow_na_array_get_valueSHIM		garrow_na_array_get_valuesSHIM		garrow_null_data_type_new		null		0	A degenerate NULL type represented as 0 bytes/bits.
GARROW_TYPE_BOOLEAN		bool		garrow_boolean_array_get_valueSHIM		garrow_boolean_array_get_values		garrow_boolean_data_type_new	bool		1	A boolean value represented as 1-bit.
GARROW_TYPE_UINT8		uint8		garrow_uint8_array_get_value		garrow_uint8_array_get_values		garrow_uint8_data_type_new		int		4	Little-endian 8-bit unsigned integer.
GARROW_TYPE_INT8		int8		garrow_int8_array_get_value		garrow_int8_array_get_values		garrow_int8_data_type_new		int		4	Little-endian 8-bit signed integer.
GARROW_TYPE_UINT16		uint16		garrow_uint16_array_get_value		garrow_uint16_array_get_valuesSHIM		garrow_uint16_data_type_new	int		4	Little-endian 16-bit unsigned integer.
GARROW_TYPE_INT16		int16		garrow_int16_array_get_value		garrow_int16_array_get_valuesSHIM		garrow_int16_data_type_new		int		4	Little-endian 16-bit signed integer.
GARROW_TYPE_UINT32		uint32		garrow_uint32_array_get_value		garrow_uint32_array_get_valuesSHIM		garrow_uint32_data_type_new	int		4	Little-endian 32-bit unsigned integer.
GARROW_TYPE_INT32		int32		garrow_int32_array_get_value		garrow_int32_array_get_valuesSHIM		garrow_int32_data_type_new		int		4	Little-endian 32-bit signed integer.
GARROW_TYPE_UINT64		uint64		garrow_uint64_array_get_value		garrow_uint64_array_get_values		garrow_uint64_data_type_new	int		4	Little-endian 64-bit unsigned integer.
GARROW_TYPE_INT64		int64		garrow_int64_array_get_value		garrow_int64_array_get_values		garrow_int64_data_type_new		int		4	Little-endian 64-bit signed integer.
GARROW_TYPE_HALF_FLOAT		float16		NA				NA				NA			float		8	2-byte floating point value.
GARROW_TYPE_FLOAT		float		garrow_float_array_get_value		garrow_float_array_get_valuesSHIM		garrow_float_data_type_new		float		8	4-byte floating point value.
GARROW_TYPE_DOUBLE		double		garrow_double_array_get_value		garrow_double_array_get_values		garrow_double_data_type_new	float		8	8-byte floating point value.
GARROW_TYPE_STRING		utf8		garrow_string_array_get_stringSHIM		garrow_string_array_get_stringsSHIM		garrow_string_data_type_new	char		2	UTF-8 variable-length string.
GARROW_TYPE_BINARY		binary		garrow_binary_array_get_value		NA				garrow_binary_data_type_new	byte		2	Variable-length bytes (no guarantee of UTF-8-ness).
GARROW_TYPE_FIXED_SIZE_BINARY	w:[n]		garrow_fixed_size_binary_array_get_value	garrow_fixed_size_binary_array_get_values_bytes	garrow_fixed_size_binary_data_type_new	byte		2	Fixed-size binary. Each value occupies the same number of bytes.
GARROW_TYPE_DATE32		date32		garrow_date32_array_get_value		garrow_date32_array_get_valuesSHIM		garrow_date32_data_type_new	int		4	int32 days since the UNIX epoch.
GARROW_TYPE_DATE64		date64		garrow_date64_array_get_value		garrow_date64_array_get_values		garrow_date64_data_type_new	int		4	int64 milliseconds since the UNIX epoch.
GARROW_TYPE_TIMESTAMP		timestamp		garrow_timestamp_array_get_value		garrow_timestamp_array_get_values		garrow_timestamp_data_type_new	int		4	Exact timestamp encoded with int64 since UNIX epoch. Default unit millisecond.
GARROW_TYPE_TIME32		time32		garrow_time32_array_get_value		garrow_time32_array_get_valuesSHIM		garrow_time32_data_type_new	int		4	Exact time encoded with int32, supporting seconds or milliseconds
GARROW_TYPE_TIME64		time64		garrow_time64_array_get_value		garrow_time64_array_get_values		garrow_time64_data_type_new	int		4	Exact time encoded with int64, supporting micro- or nanoseconds
GARROW_TYPE_INTERVAL_MONTHS	intervalmonths	NA				NA				NA			char		4	YEAR_MONTH interval in SQL style.
GARROW_TYPE_INTERVAL_DAY_TIME	intervaldaystime	NA				NA				NA			char		4	DAY_TIME interval in SQL style.
GARROW_TYPE_DECIMAL128		int128		garrow_decimal128_array_get_value		NA				garrow_decimal128_data_type_new	float		8	Precision- and scale-based decimal type with 128-bit. Storage type depends on the parameters.
GARROW_TYPE_DECIMAL256		int256		garrow_decimal256_array_get_value		NA				garrow_decimal256_data_type_new	float		8	Precision- and scale-based decimal type with 256-bit. Storage type depends on the parameters.
GARROW_TYPE_LIST		list		garrow_list_array_get_value		garrow_list_array_get_values		NA			NA		0	A list of some logical data type.
GARROW_TYPE_STRUCT		struct		garrow_struct_array_get_field		garrow_struct_array_get_fields		NA			NA		0	Struct of logical types.
GARROW_TYPE_SPARSE_UNION		sparseunion		NA				NA				NA			NA		0	Sparse unions of logical types.
GARROW_TYPE_DENSE_UNION		denseunion		NA				NA				NA			NA		0	Dense unions of logical types.
GARROW_TYPE_DICTIONARY		dictionary		NA				garrow_dictionary_array_get_indicesSHIM		NA			int		4	Dictionary aka Category type.
GARROW_TYPE_MAP		map		NA				NA				NA			NA		0	A repeated struct logical type.
GARROW_TYPE_EXTENSION		extension		NA				NA				NA			NA		0	Custom data type, implemented by user.
GARROW_TYPE_FIXED_SIZE_LIST	flist		NA				NA				NA			NA		0	Fixed size list of some logical type.
GARROW_TYPE_DURATION		duration		NA				NA				NA			NA		0	Measure of elapsed time in either seconds, milliseconds, microseconds or nanoseconds.
GARROW_TYPE_LARGE_STRING		large_utf8		garrow_large_string_array_get_string		NA				garrow_large_string_data_type_new	char		2	64bit offsets UTF-8 variable-length string.
GARROW_TYPE_LARGE_BINARY		large_binary		garrow_large_binary_array_get_value		NA				garrow_large_binary_data_type_new	char		2	64bit offsets Variable-length bytes (no guarantee of UTF-8-ness).
GARROW_TYPE_LARGE_LIST		large_list		garrow_large_list_array_get_value		garrow_large_list_array_get_values				NA			NA		0	A list of some logical data type with 64-bit offsets.
)

typeTranslation =: |: >@(cut&.>)@(LF&cut)@detab 0 : 0 NB. schema text vs typeName
date32[day]	date32
date64[day]	date64
string	utf8
)

typeIndexLookup=: {{> x {~ y}}
typeNameIndex=: (typeName&i.)@<
typeNameLookup=: {{> x {~ typeNameIndex y}}
NB. typeNameIndex each typeName


NB. Examples:
NB. typeNameIndex 'float'
NB. typeGetValue&typeNameLookup 'float'
NB. typeNameIndex 'utf8'
NB. typeDescription typeNameLookup 'utf8'
NB. typeGetValue&typeNameLookup 'utf8'
NB. typeNew&typeNameLookup 'float'

NB. Date from Unix epoch 1970-01-01
NB. fromdate32 0, 18262
fromdate32 =: {{
a=. 719468.75 + , y
c=. <. 36524.25 %~ a
d=. <. a - 36524.25 * c
db=. <. 365.25 %~ ( d+0.75) 
da=. <. 1.75 + d - 365.25 * db
mm =. <. 30.6 %~ (da - 0.59)
((c*100)+db+mm >: 10),.(1+12 | mm+2),.<. 0.41 + da - 30.6 * mm
}}

fromdatetime64 =: (6!:16)
9!:5 (1) NB. Enable nameref caching.
init ''

fileExistAssert=: ('File does not exist.'&assert)@fexist@jpath
initError=: {{ < r [ 0 memw (r=. mema 2^2+IF64),0,1,4 }}
checkError=: {{
ie=. > memr (>y),0,1,4
if. ie do.
  message=. getString < memr (ie),8,1,4
  g_error_free << {. memr (>y),0,1,4
else.
  message=. 'unknown'
  memf > y
end.
message assert 0 = ie
}}


NB. =========================================================
NB. Object and property management
NB. =========================================================
removeObject=: -.@ret@g_object_unref@<

getPropertyBoolean=: {{
'objectPtr propertyName'=. y
propertyPtr=. setString propertyName
valPtr=. < mema 8
ret g_object_get objectPtr;propertyPtr;valPtr;<<0 	NB. Need to terminate in a null pointer.
1 getInts valPtr
}}

setPropertyBoolean=: {{
'objectPtr propertyName propertyValue'=. y
propertyPtr=. setString propertyName
g_object_set objectPtr;propertyPtr;propertyValue;<<0 	NB. Need to terminate in a null pointer.
res=. getPropertyBoolean objectPtr;propertyName
res
}}


NB. =========================================================
NB. Array
NB. =========================================================
readArrayType=: {{
'arrayPt'=. y
arrayTypePtr=. ptr garrow_array_get_value_data_type < arrayPt
namePtr=. ret garrow_data_type_get_name < arrayTypePtr
res=. getString namePtr
g_free << namePtr
removeObject arrayTypePtr
res
}}

readArrayTypeIndex=: {{
'arrayPt'=. y
arrayTypePtr=. ptr garrow_array_get_value_data_type < arrayPt
res=. ret garrow_data_type_get_id < arrayTypePtr
removeObject arrayTypePtr
res
}}

readArrayBitWidth=: {{
'arrayPt'=. y
dataWidthPtr=. ptr garrow_array_get_value_data_type < arrayPt
res=. ret garrow_fixed_width_data_type_get_bit_width < dataWidthPtr
removeObject dataWidthPtr
res
}}

readArrayLength=: {{ret garrow_array_get_length < y}}

readArrayRows=: {{
NB. Use this only for reading parts of arrays.
'arrayPt rowIndices'=. y
indexType=. readArrayTypeIndex arrayPt
arrayType=. readArrayType arrayPt
length=. readArrayLength arrayPt
getValueFunc=. typeGetValue&typeIndexLookup indexType NB. lookup functions
fRun=. getValueFunc,', arrayPt;<'
('Max row index must be  less than row count of ',": length) assert (>./ rowIndices) <: length
results=. ; ret@". each (fRun&,)@": each <"0 (rowIndices)
NB. width =. readArrayBitWidth arrayPt
NB. lengthPt =. setInts length
NB. getValuesFunc =. typeGetValues&typeIndexLookup indexType NB. lookup functions
NB. arrayValuesPt =.  ptr ". getValuesFunc,', (arrayPt);<lengthPt'
NB. Jtype =.  ". typeJMemr&typeIndexLookup indexType
NB. results =. memr (ret arrayValuesPt),0,length,Jtype
NB. memf > lengthPt
results
}}

readArray=: {{
NB. Read the whole array at once instead of one call for each.
'arrayPt'=. y
indexType=. readArrayTypeIndex arrayPt
arrayType=. readArrayType arrayPt
fRun=. typeGetValues&typeIndexLookup indexType NB. lookup functions
Jtype=. ". typeJMemr&typeIndexLookup indexType
lengthPtr=. setInts ] length=. readArrayLength arrayPt
if. indexType e. (0,4,5,6,7,11,13,16,19,29) do.  NB. Shims for getValues return values directly instead of pointers.
  result=. > (fRun)~ arrayPt;<lengthPtr
else.
  resPtr=. ptr (fRun)~ arrayPt;<lengthPtr
  result=. memr (>resPtr),0,length,Jtype
  if. indexType = 1 do. g_free < resPtr end. NB. Boolean array values must be freed for some reason.
end.
memf > lengthPtr
nullCount=. ret garrow_array_get_n_nulls < arrayPt
NB.   if. (* nullCount) do. <arrayPt
NB.    nullBufferPtr =. ptr garrow_array_get_null_bitmap <arrayPt
NB.    echo 'null buffer ptr'; nullCount; nullBufferPtr;(>. length % 8)
NB.    echo nullBitMap =. _8 ic memr (> ptr getBuffer nullBufferPtr),0,(>. length),2
NB.   end.
result
}}"0

readSubArray=: {{
NB. Use this only for reading parts of arrays.
NB. Currently iterates through everything...
'arrayPt'=. y
indexType=. readArrayTypeIndex arrayPt
arrayType=. readArrayType arrayPt
length=. readArrayLength arrayPt
getValueFunc=. typeGetValue&typeIndexLookup indexType NB. lookup functions
fRun=. getValueFunc,', arrayPt;<'
results=. ; ret@". each (fRun&,)@": each <"0 i.length
NB. width =. readArrayBitWidth arrayPt
NB. lengthPt =. setInts length
NB. getValuesFunc =. typeGetValues&typeIndexLookup indexType NB. lookup functions
NB. arrayValuesPt =.  ptr ". getValuesFunc,', (arrayPt);<lengthPt'
NB. Jtype =.  ". typeJMemr&typeIndexLookup indexType
NB. results =. memr (ret arrayValuesPt),0,length,Jtype
NB. memf > lengthPt
results
}}


NB. =========================================================
NB. chunkedArray
NB. =========================================================
readChunk=: {{
'chunkedArrayPt index'=. y
ptr@garrow_chunked_array_get_chunk chunkedArrayPt;index
}}

readChunks=: {{
'chunkedArrayPt'=. y
nChunks=. ret@garrow_chunked_array_get_n_chunks < chunkedArrayPt
arrayPts=. readChunk each <"1 (<chunkedArrayPt),.(<"0 i. nChunks)
res=. < ; readArray each arrayPts
removeObject each arrayPts
res
}}"0

readChunkedArray=: {{
'chunkedArrayPt'=. y
NB. length =. > ptr@garrow_chunked_array_get_length < chunkedArrayPt
NB. valuetype =. > ptr@garrow_chunked_array_get_value_type < chunkedArrayPt
NB. nrows  =. > ptr@garrow_chunked_array_get_n_rows < chunkedArrayPt
NB. nnulls =. > ptr@garrow_chunked_array_get_n_nulls < chunkedArrayPt
NB. valuedatatype =. ptr@garrow_chunked_array_get_value_data_type < chunkedArrayPt
NB. length;nrows;nnulls;valuetype;<valuedatatype
readChunks chunkedArrayPt
}}"0

NB. =========================================================
NB. Field
NB. =========================================================
newField=: {{
'name dataType nullableBoolean'=. 3 {. y
typeArgs=. 3 }. y
namePtr=. setString name
dtFn=. typeNew&typeNameLookup dataType
datatypePtr=. ptr (dtFn)~ ''
fieldPtr=. ptr garrow_field_new_full namePtr;datatypePtr;nullableBoolean
fieldPtr
}}

getFieldName=: {{
'fieldPt'=. y
fieldNamePtr=. ptr garrow_field_get_name < fieldPt
res=. getString fieldNamePtr
res
}}

getFieldDataType=: {{
'fieldPt'=. y
dataTypePtr=. ptr garrow_field_get_data_type < fieldPt
namePtr=. ret garrow_data_type_get_name < dataTypePtr
res=. getString namePtr
g_free << namePtr
removeObject dataTypePtr
res
}}

NB. =========================================================
NB. Schema
NB. =========================================================
getSchemaPt=: {{
tablePt=. y
ptr garrow_table_get_schema < tablePt
}}

getSchemaFieldPt=: {{
'schemaPt index'=. y
ptr garrow_schema_get_field schemaPt;index
}}

getSchemaName=: {{
'schemaPt index'=. y
fieldPts=. getSchemaFieldPt (<schemaPt),< index
name=. getFieldName fieldPts
removeObject fieldPts
name
}}

getSchemaNames=: {{
schemaPt=. y
nFields=. ret garrow_schema_n_fields < schemaPt
names=. getSchemaName each <"1 (<schemaPt),.<"0 i. nFields
names
}}

getSchemaFields=: {{
schemaPt=. y
nFields=. ret garrow_schema_n_fields < schemaPt
fieldPts=. getSchemaFieldPt each <"1 (<schemaPt),.<"0 i. nFields
types=. getFieldDataType each fieldPts
names=. getFieldName each fieldPts
res=. names,:types
NB. removeObject each fieldPts NB. returns g_object_unref: assertion 'G_IS_OBJECT (object)' failed
res
}}

printBasicSchema=: {{
tablePt=. y
schemaPt=. getSchemaPt tablePt
res=. getString ret ptr garrow_schema_to_string < schemaPt
removeObject schemaPt
res
}}

printTableSchema=: (,.~(,.&' ')@(":@,.@:i.@#))@:>@:(LF&cut)@printBasicSchema

readTableNames=: {{
tablePt=. y
schemaPt=. getSchemaPt tablePt
res=. getSchemaNames schemaPt
removeObject schemaPt
res
}}

readTableSchema=: {{
tablePt=. y
schemaPt=. getSchemaPt tablePt
res=. getSchemaFields schemaPt
removeObject schemaPt
res
}}

readTableColName=: {{
'tablePt index'=. y
schemaPt=. getSchemaPt tablePt
res=. getSchemaName schemaPt;<index
removeObject schemaPt
res
}}

NB. Make a schema from a text file with fieldname fieldtype [nullableBoolean]
schemFileaBox=: {{ dltb &.> > ':'&cut (&.>) (LF&cut) fread jpath y }}

makeField=: {{
NB. Two or three args, fieldname fieldType nullableBoolean
'fieldname fieldType'=. 2 {. y
if. 1 = (3!:0) > {: y do.   NB. If  three-length box row is a integer, assume this is a
  'nullableBoolean must be either 0 or 1' assert 1 = (3!:0) > {: < 1
  nullableBoolean=. > {: y
else.
  nullableBoolean=. 0
end.
fieldType=. > (({: typeTranslation),<fieldType) {~ (<fieldType) i.~ ({. typeTranslation),<fieldType   NB. Translate fieldtypes from string to utf8
('Invalid datatype: ',fieldType) assert typeName e.~ (<fieldType)
index=. typeNameIndex fieldType
NB. fnewtype =. typeNew&typeNameLookup fieldtype
NB. typePtr =. ptr ".  fnewtype,''''''
ptr newField fieldname;fieldType;nullableBoolean
}}"1

schemaFromTable=: {{ptr@garrow_schema_new@<@newList makeField y }}

scheemaReadFile=: schemaFromTable@schemFileaBox


NB. =========================================================
NB. Table
NB. =========================================================
tableNRows=: {{ret garrow_table_get_n_rows (< y)}}
tableNCols=: {{ret garrow_table_get_n_columns (< y)}}

readData=: {{
'tablePt'=. y
ncols=. tableNCols tablePt
chunkedArrayPts=. ptr"1 garrow_table_get_column_data tablePt ;"0 i. ncols
res=. ,. readChunks chunkedArrayPts
removeObject"0 chunkedArrayPts
res
}}

readsData=: ,@((,.&.>)@:readData)

readDataInverted=: ,@:(,each)@readData

readDataCol=: {{
'tablePt colIndex'=. y
ncols=. tableNCols tablePt
'Index is greater than number of columns. Note columns are zero-indexed.' assert colIndex < ncols
chunkedArrayPts=. <"0 ptr"1 garrow_table_get_column_data (< tablePt), < colIndex
results=. ,. ; each readChunks each chunkedArrayPts
removeObject each chunkedArrayPts
results
}}

readCol=: {{
'tablePt colIndex'=. y
((<@readTableColName),.readDataCol) (< tablePt),< colIndex
}}

readTable=: {{
'tablePt'=. y
(readTableNames ,. ,@readData) tablePt
}}

readsTable=: {{
'tablePt'=. y
(,@readTableNames ,: readsData) tablePt
}}

readDataframe=: {{
'tablePt'=. y
((,@readTableNames),: ,@readData) tablePt
}}

NB. =========================================================
NB. Format readers
NB. =========================================================
readFileSchema=: {{ readTableSchema@u ] filepath=. y }}
printFileSchema=: {{ printBasicSchema@u ] filepath=. y }}
readFileData=: {{ readData@u ] filepath=. y }}
readFileTable=: {{ readTable@u ] filepath=. y }}
readsFileTable=: {{ readsTable@u ] filepath=. y }}
readFileDataframe=: {{ readDataframe@u ] filepath=. y }}
readFileCol=: {{
'filepath index'=. y
readCol (u filepath);<index
}}


NB. =========================================================
NB. CSV format
NB. Add CSV options. Is it necessary to close reader?
NB. =========================================================
readCSV=: {{
'filepath'=. y
'File does not exist or is not permissioned for read.' assert fexist (jpath filepath)
filenamePtr=. setString (jpath filepath)
e=. initError ''
fInputStreamPtr=. ptr garrow_file_input_stream_new filenamePtr;<e
checkError e
'Check file exists and permissions.' assert * > fInputStreamPtr
NB. Example adding column names:
readOptionPtr=. ptr garrow_csv_read_options_new ''
garrow_csv_read_options_add_schema readOptionPtr;<
NB. '"/usr/local/lib/libarrow-glib.dylib" garrow_csv_read_options_add_column_name n * *'&cd (< ptr rdOptPt ),(<< setString 'col1')
NB. ptr i32 =. '"/usr/local/lib/libarrow-glib.dylib" garrow_int32_data_type_get_type *'&cd ''
NB. '"/usr/local/lib/libarrow-glib.dylib" garrow_csv_read_options_add_column_type n * * *'&cd (< ptr rdOptPt ),(< setString 'col1');(< ptr i32)
e=. initError ''
csvReaderPtr=. ptr garrow_csv_reader_new (fInputStreamPtr);(readOptionPtr);<e
checkError e
e=. initError ''
tablePtr=. ptr garrow_csv_reader_read csvReaderPtr;<e
checkError e
removeObject"0 csvReaderPtr,readOptionPtr,fInputStreamPtr
memf > filenamePtr
tablePtr
}}

readCSVSchema=: (readCSV readFileSchema)
printCSVSchema=: (readCSV printFileSchema)
readCSVData=: (readCSV readFileData)
readCSVTable=: (readCSV readFileTable)
readsCSVTable=: (readCSV readsFileTable)
readCSVDataframe=: (readCSV readFileDataframe)
readCSVCol=: (readCSV readFileCol)


NB. =========================================================
NB. JSON lines format
NB. =========================================================
readJson=: {{
'filepath'=. y
'File does not exist or is not permissioned for read.' assert fexist (jpath filepath)
filenamePtr=. setString (jpath filepath)
e=. initError ''
fInputStreamPtr=. ptr garrow_file_input_stream_new filenamePtr;<e
checkError e
'Check file exists and available will permissions.' assert * > ptr fInputStreamPtr
readOptionPtr=. ptr garrow_json_read_options_new ''
e=. initError ''
jsonReaderPtr=. ptr garrow_json_reader_new fInputStreamPtr;readOptionPtr;<e
checkError e
e=. initError ''
tablePtr=. ptr garrow_json_reader_read jsonReaderPtr;<e
checkError e
'Invalid JSON-format.' assert > tablePtr
removeObject"0 readOptionPtr, fInputStreamPtr, jsonReaderPtr
memf > filenamePtr
tablePtr
}}

readJsonSchema=: (readJson readFileSchema)
printJsonSchema=: (readJson printFileSchema)
readJsonData=: (readJson readFileData)
readJsonTable=: (readJson readFileTable)
readsJsonTable=: (readJson readsFileTable)
readJsonDataframe=: (readJson readFileDataframe)
readJsonCol=: (readJson readFileCol)


NB. =========================================================
NB. Parquet format
NB. =========================================================
readParquet=: {{
'filepath'=. y
'File does not exist or is not permissioned for read.' assert fexist (jpath filepath)
e=. initError ''
readerPathPtr=. ptr gparquet_arrow_file_reader_new_path (jpath filepath);<e
checkError e
e=. initError ''
tablePtr=. ptr gparquet_arrow_file_reader_read_table readerPathPtr;<e
checkError e
removeObject readerPathPtr
tablePtr
}}

NB. readParquetSchema=: (readParquet readFileSchema)
readParquetSchema=: {{
NB. use gparquet_arrow_file_reader_get_schema instead of reading entire file into memory first
'filepath'=. y
'File does not exist or is not permissioned for read.' assert fexist (jpath filepath)
e=. < mema 4
readerPathPtr=. ptr gparquet_arrow_file_reader_new_path (jpath filepath);<e
schemaPt=. ptr gparquet_arrow_file_reader_get_schema readerPathPtr;<e
removeObject readerPathPtr
memf > e
res=. getSchemaFields schemaPt
removeObject schemaPt
res
}}

printParquetSchema=: (readParquet printFileSchema)
readParquetData=: (readParquet readFileData)
readParquetTable=: (readParquet readFileTable)
readsParquetTable=: (readParquet readsFileTable)
readParquetDataframe=: (readParquet readFileDataframe)
readParquetCol=: (readParquet readFileCol)

NB. writeParquet tablePointer;'~out1.parquet'
NB. Add write options
writeParquet=: {{
'tablePtr filepath'=. y
pqtWtrPtr=. ptr gparquet_writer_properties_new ''
schemaPtr=. ptr getSchemaPt tablePtr
filenamePtr=. setString filepath
e=. initError ''
pqtFileWriterPtr=. ptr gparquet_arrow_file_writer_new_path schemaPtr;filenamePtr;pqtWtrPtr;<e
checkError e
chunksize=. 5000
e=. initError ''
success=. ret gparquet_arrow_file_writer_write_table pqtFileWriterPtr;tablePtr;chunksize;<e
checkError e
e=. initError ''
gparquet_arrow_file_writer_close pqtFileWriterPtr;<e
checkError e
removeObject"0 pqtWtrPtr, schemaPtr, pqtFileWriterPtr
memf > (filenamePtr)
success
}}


NB. =========================================================
NB. Feather format ('Version 1')
NB. =========================================================
readFeather=: {{
NB. Properties
NB. gint	max-recursion-depth	Read / Write
NB. gboolean	use-threads	Read / Write
NB. gint	alignment	Read / Write
NB. gboolean	allow-64bit	Read / Write
NB. GArrowCodec *	codec	Read / Write
NB. gint	max-recursion-depth	Read / Write
NB. gboolean	use-threads	Read / Write
NB. gboolean	write-legacy-ipc-format	Read / Write
'filepath'=. y
'File does not exist or is not permissioned for read.' assert fexist (jpath filepath)
filenamePtr=. setString (jpath filepath)
e=. initError ''
fInputStreamPtr=. ptr garrow_file_input_stream_new filenamePtr;<e
checkError e
'Check file exists and available will permissions.' assert * > ptr fInputStreamPtr
e=. initError ''
arrowReaderPtr=. ptr garrow_feather_file_reader_new fInputStreamPtr;<e
checkError e
'Null pointer error' assert > arrowReaderPtr
e=. initError ''
tablePtr=. ptr garrow_feather_file_reader_read arrowReaderPtr;<e
checkError e
removeObject"0 fInputStreamPtr,arrowReaderPtr
memf > filenamePtr
tablePtr
}}

readFeatherSchema=: (readFeather readFileSchema)
printFeatherSchema=: (readFeather printFileSchema)
readFeatherData=: (readFeather readFileData)
readFeatherTable=: (readFeather readFileTable)
readsFeatherTable=: (readFeather readsFileTable)
readFeatherDataframe=: (readFeather readFileDataframe)
readFeatherCol=: (readFeather readFileCol)

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

NB. FILE FORMAT: ".arrow"
NB. We recommend the “.arrow” extension for files created with this format. Note that files created with this format are sometimes called “Feather V2” or with the “.feather” extension, the name and the extension derived from “Feather (V1)”, which was a proof of concept early in the Arrow project for language-agnostic fast data frame storage for Python (pandas) and R.
NB. Arrow IPC 'file format' schema
NB. 	<magic number "ARROW1">
NB. 	<empty padding bytes [to 8 byte boundary]>
NB. 	<STREAMING FORMAT with EOS>
NB. 	<FOOTER>
NB. 	<FOOTER SIZE: int32>
NB. <magic number "ARROW1">
NB. STREAMING FORMAT: ".arrows"
NB. We recommend the “.arrows” file extension for the streaming format although in many cases these streams will not ever be stored as files.
NB. 	The stream writer can signal end-of-stream (EOS) either by writing 8 bytes containing the 4-byte continuation indicator (0xFFFFFFFF) followed by 0 metadata length (0x00000000) or closing the stream interface.
NB. https://arrow.apache.org/docs/format/Columnar.html

NB. IPC Format
NB. The columnar IPC protocol utilizes a one-way stream of binary messages of these types:
NB. 1) Schema 2) RecordBatch 3) DictionaryBatch
NB. The message encapsulation format in flatbuffers
NB. https://arrow.apache.org/docs/format/Columnar.html#encapsulated-message-format


NB. There are two concepts of streams in Arrow; the term is overloaded and this is a a source of confusion.
NB. 1) Input and output streams, which reference interfaces to data stores.
NB. 2) The writers for IPC-format files without footers, suitable for streaming.
NB. The difference between RecordBatchFileReader and RecordBatchStreaader
NB. is that the input source must have a seek method for random access.

NB. Event-driven API
NB. https://arrow.apache.org/docs/cpp/api/ipc.html#event-driven-api
NB. listener StreamDecoder


NB. =========================================================

newList=: {{
items=. y
listPtr=. <0
for_item. items do.
  listPtr=. ptr g_list_append listPtr;<item
end.
listPtr
}}

setBytes=: {{
byteCount=. # y
NB. bytePtr =. mema  byteCount
bytePtr=. > ptr g_malloc <byteCount
y memw bytePtr,0,byteCount,2
NB. gBtyesPtr =. ptr g_bytes_new_static (<bytePtr);byteCount
gBtyesPtr=. ptr g_bytes_new_take (<bytePtr);byteCount
gBtyesPtr
}}

newResizableBuffer=: {{
e=. initError ''
res=. ptr garrow_resizable_buffer_new 1;<e
checkError e
res
}}

newSchema=: {{
NB. 'name dataType nullableBoolean'
fields=. y
fieldPtrs=. newField"1 fields
listPtr=. newList fieldPtrs
schemaPtr=. ptr garrow_schema_new <listPtr
schemaPtr
}}

makeReadOptions=: {{
readoptions=. y
readOptionsPtr=. garrow
NB. "max-recursion-depth"	gint
NB. "use-threads"	gboolean
readOptionsPtr=. ptr garrow_read_options_new ''
NB. setProperties
readOptionsPtr
}}

makeWriteOptions=: {{
readoptions=. y
NB. "use-threads"	gboolean
NB. "alignment"	gint
NB. "allow-64bit" 	gboolean
NB. "codec"		GArrowCodec *
NB. "max-recursion-depth"	gint
NB. "use-threads"	gboolean
NB. "write-legacy-ipc-format"	gboolean
writeOptionsPtr=. ptr garrow_write_options_new ''
NB. setProperties
writeOptionsPtr
}}


NB. =========================================================
NB. Input streams
NB. =========================================================

fileInputStream=: {{
filepath=. y
'File does not exist.' assert fexist jpath filepath
filePtr=. setString jpath filepath
e=. initError ''
inputStreamPtr=. ptr garrow_file_input_stream_new filePtr;<e
checkError e
e=. initError ''
garrow_input_stream_align inputStreamPtr;64;<e
checkError e
inputStreamPtr
}}

bufferInputStream=: {{
gBtyesPtr=. y
bufferPtr=. ptr garrow_buffer_new_bytes <gBtyesPtr
bufferInputStreamPtr=. ptr garrow_buffer_input_stream_new <bufferPtr
e=. initError ''
garrow_input_stream_align bufferInputStreamPtr;64;<e
checkError e
bufferInputStreamPtr
}}

memmoryMappedFileInputStream=: {{
filepath=. y
'File does not exist.' assert fexist jpath filepath
filePtr=. setString jpath filepath
e=. initError ''
inputStreamPtr=. ptr garrow_memory_mapped_input_stream_new filePtr;<e
checkError e
e=. initError ''
garrow_input_stream_align inputStreamPtr;64;<e
checkError e
inputStreamPtr
}}

gioInputStream=: {{
inputStream=. y
inputStreamPtr=. ptr garrow_gio_input_stream_new inputStream
e=. initError ''
garrow_input_stream_align inputStreamPtr;64;<e
checkError e
inputStreamPtr
}}

codec=: {{
compressionTypes=. 'UNCOMPRESSED SNAPPY GZIP BROTLI ZSTD LZ4 LZO BZ2'
NB. UNCOMPRESSED Not compressed.
NB. SNAPPY Snappy compression.
NB. GZIP gzip compression.
NB. BROTLI Brotli compression.
NB. ZSTD Zstandard compression.
NB. LZ4 LZ4 compression.
NB. LZO LZO compression.
NB. BZ2 bzip2 compression.
compression=. y
compressionEnum=. {. (< tolower compression) I.@E. ;: tolower compressionTypes
e=. initError ''
codecPtr=. ptr garrow_codec_new compressionEnum;<e
checkError e
if. -. * > codecPtr do.
  echo 'Invalid compression type. Valid compression types are: ', > ;: 'UNCOMPRESSED SNAPPY GZIP BROTLI ZSTD LZ4 LZO BZ2'
  codecPtr=. <0
else.
NB. echo ret garrow_codec_get_compression_type  < codecPtr
NB. codecNamePtr =. ptr garrow_codec_get_name < codecPtr
end.
codecPtr
}}

compressedInputStream=: {{
'codecName inputStreamPtr'=. y
codePtr=. codec codecName
e=. initError ''
inputStreamPtr=. ptr garrow_compressed_input_stream_new codecPtr;inputStreamPtr;<e
checkError e
e=. initError ''
garrow_input_stream_align inputStreamPtr;64;<e
checkError e
inputStreamPtr
}}



NB. =========================================================
NB. Output streams
NB. =========================================================


fileOutputStream=: {{
'filepath appendboolean'=. y
fnPtr=. setString jpath filepath
e=. initError ''
fileOutputStreamPtr=. ptr garrow_file_output_stream_new fnPtr;appendboolean;<e
checkError e
fileOutputStreamPtr
}}

bufferOutputStream=: {{
ptr garrow_buffer_output_stream_new < newResizableBuffer''
}}

newCompressedOutputStream=: {{
'codecPtr outputStreamPtr'=. y
e=. initError ''
compressedOutputStreamPtr=. ptr garrow_compressed_output_stream_new codecPtr;outputStreamPtr;<e
checkError e
compressedOutputStreamPtr
}}

NB. gio_output_stream

NB. =========================================================
NB. IPC WRITER CLASSES
NB. =========================================================

writeRecordBatchStream=: {{
NB. IPC stream format is  optionally footer-terminated and
NB. it does not contain ARROW1 magic numbers at beginning and end.
'outputStreamPtr recordBatchPtrs'=. y
e=. initError ''
ret garrow_output_stream_align outputStreamPtr;64;<e
checkError e
writeOptionsPtr=. makeWriteOptions ''
schemaPtr=. ptr garrow_record_batch_get_schema < {. recordBatchPtrs
e=. initError ''
recordBatchStreamWriterPtr=. ptr garrow_record_batch_stream_writer_new outputStreamPtr;schemaPtr;<e
checkError e
for_recordBatchPtr. recordBatchPtrs do.
  e=. initError ''
  garrow_record_batch_writer_write_record_batch recordBatchStreamWriterPtr;recordBatchPtr;<e
  checkError e
end.
e=. initError ''
garrow_record_batch_writer_close recordBatchStreamWriterPtr;<e
checkError e
outputStreamPtr
}}

writeRecordBatchFileOutputStream=: {{
'filepath appendboolean recordBatchPtrs'=. y
'File does not exist.' assert fexist jpath filepath
outputStreamPtr=. fileOutputStream filepath;appendboolean
writeRecordBatchStream outputStreamPtr;<recordBatchPtrs
outputStreamPtr
}}

writeRecordBatchBufferOutputStream=: {{
recordBatchPtrs=. y
outputStreamPtr=. bufferOutputStream''
writeRecordBatchStream outputStreamPtr;<recordBatchPtrs
outputStreamPtr
}}

writeRecordBatchCompressedOutputStream=: {{
'codecPtr outputStreamPtr recordBatchPtrs'=. y
outputStreamPtr=. newCompressedOutputStream codecPtr;outputStreamPtr
writeRecordBatchStream outputStreamPtr;<recordBatchPtrs
outputStreamPtr
}}

writeRecordBatchGIOOutputStream=: {{
'gio_output_stream recordBatchPtrs'=. y
outputStreamPtr=. garrow_gio_output_stream_new gio_output_stream NB. FIX
writeRecordBatchStream outputStreamPtr;<recordBatchPtrs
outputStreamPtr
}}


recordBatchFileWriter=: {{
'outputStreamPtr schemaPtr'=. y
e=. initError ''
recordbatchFilestreamWriterPtr=. ptr garrow_record_batch_file_writer_new outputStreamPtr;schemaPtr;<e
checkError e
recordbatchFilestreamWriterPtr
}}

writeRecordBatchFile=: {{
NB. Write '.arrow' file.
NB. The IPC file format is footer-terminated and contains ARROW1 magic numbers at beginning and end.
'filepath appendboolean recordBatchPtrs'=. y
'File does not exist.' assert fexist jpath filepath
fileOutputStreamPtr=. fileOutputStream filepath;appendboolean
e=. initError ''
ret garrow_output_stream_align fileOutputStreamPtr;64;<e
checkError e
writeOptionsPtr=. (makeWriteOptions '')
schemaPtr=. ptr garrow_record_batch_get_schema < {. recordBatchPtrs
recordbatchFilestreamWriterPtr=. recordBatchFileWriter fileOutputStreamPtr;<schemaPtr
for_recordBatchPtr. recordBatchPtrs do.
  e=. initError ''
  garrow_record_batch_writer_write_record_batch recordbatchFilestreamWriterPtr;recordBatchPtr;<e
  checkError e
end.
e=. initError ''
success=. ret garrow_record_batch_writer_close recordbatchFilestreamWriterPtr;< e
checkError e
success
}}

writeTableFile=: {{
'filepath appendboolean tablePtr'=. y
'File does not exist.' assert -. appendboolean * -. fexist jpath filepath
schemaPtr=. getSchemaPt tablePtr
recordBatchFileWriterPtr=. recordBatchFileWriter (fileOutputStream filepath;appendboolean);<schemaPtr
e=. initError ''
success1=. ret garrow_record_batch_writer_write_table recordBatchFileWriterPtr;tablePtr;<e
checkError e
e=. initError ''
success2=. ret garrow_record_batch_writer_close recordBatchFileWriterPtr;<e
checkError e
>./ success1, success2
}}

writeTensorFile=: {{
'filepath appendboolean tensorPtr'=. y
'File does not exist.' assert fexist jpath filepath
fileOutputStreamPtr=. fileOutputStream filepath;appendboolean
e=. initError ''
res=. ret garrow_output_stream_write_tensor outputStreamPtr;tensorPtr;<e
checkError e
res
}}

NB. =========================================================
NB. IPC READER CLASSES
NB. =========================================================

readFileStreamRecordBatches=: {{
NB. Necessary for '.arrows' file (does not have an end marker and is not seekable)
filepath=. y
'File does not exist.' assert fexist jpath filepath
fileInputStreamPtr=. fileInputStream filepath
e=. initError ''
ret garrow_input_stream_align fileInputStreamPtr;64;<e
checkError e
e=. initError ''
rbreaderPtr=. ptr garrow_record_batch_stream_reader_new fileInputStreamPtr;<e
checkError e
'Not a valid recordbatchReader.' assert * > rbreaderPtr
e=. initError ''
'[+] Size: ', ": ret garrow_seekable_input_stream_get_size fileInputStreamPtr;<e
checkError e
garrow_record_batch_reader_get_schema < rbreaderPtr
recordBatchPtrs=. >a:
whilst. > rb do.
  e=. initError ''
  rb=. ptr garrow_record_batch_reader_read_next rbreaderPtr;<e
  checkError e
  if. > rb do.
    recordBatchPtrs=. recordBatchPtrs, rb
  end.
end.
('Not a valid recordbatch.'&assert)@* each recordBatchPtrs
recordBatchPtrs
}}

readFileRecordBatches=: {{
NB. Necessary for '.arrow' file (i.e. has a end marker and is seekable)
filepath=. y
'File does not exist.' assert fexist jpath filepath
fileInputStreamPtr=. fileInputStream filepath
e=. initError ''
ret garrow_input_stream_align fileInputStreamPtr;64;<e
checkError e
NB. echo '[+] Size: ', ": ret garrow_seekable_input_stream_get_size fileInputStreamPtr;<e
e=. initError ''
rbreaderPtr=. ptr garrow_record_batch_file_reader_new fileInputStreamPtr;<e
checkError e
'Not a valid recordbatchReader.' assert * > rbreaderPtr
NB. schemaPtr =. ptr garrow_record_batch_file_reader_get_schema <rbreaderPtr
recordBatchCount=. ret garrow_record_batch_file_reader_get_n_record_batches <rbreaderPtr
NB. echo '[+] Recordbatch count: ', ":ret garrow_record_batch_file_reader_get_n_record_batches <rbreaderPtr
NB. ptr garrow_input_stream_read_record_batch fileInputStreamPtr;schemaPtr;makeReadOptions'');<e
e=. initError ''
recordBatchPtrs=. (ptr@garrow_record_batch_file_reader_read_record_batch)"1 rbreaderPtr ;"0 1 (i. recordBatchCount);"0 0<e
checkError e
('Not a valid recordbatch.'&assert)@* each recordBatchPtr
recordBatchPtrs
}}

readFileStreamTable=: {{
NB. read input stream directly to table from '.arrow' file.
filepath=. y
'File does not exist.' assert fexist jpath filepath
inputStreamPtr=. fileInputStream filepath
e=. initError ''
streamReaderPtr=. ptr garrow_record_batch_stream_reader_new inputStreamPtr;<e
checkError e
e=. initError ''
tablePtr=. ptr garrow_record_batch_reader_read_all streamReaderPtr;<e
checkError e
removeObject inputStreamPtr
removeObject streamReaderPtr
tablePtr
}}

recordBatchTable=: {{
recordBatches=. y
schemaPtr=. ptr garrow_record_batch_get_schema < {. recordBatches
recordBatchArrayPointer=. setInts > recordBatches
countRecordBatches=. # recordBatches
e=. initError ''
tablePtr=. ptr garrow_table_new_record_batches schemaPtr;recordBatchArrayPointer;countRecordBatches;<e
checkError e
tablePtr
}}

byteInputStream=: {{
bytes=. y
byteCount=. # bytes
bytePtr=. > ptr g_malloc <byteCount
bytes memw bytePtr,0,byteCount,2
gBtyesPtr=. ptr g_bytes_new_take (<bytePtr);byteCount
bufferPtr=. ptr garrow_buffer_new_bytes <gBtyesPtr
g_bytes_unref < gBtyesPtr NB. Must use bytes unref, NOT object unref. Object unref will cause segfault.
bufferInputStreamPtr=. ptr garrow_buffer_input_stream_new <bufferPtr
'Not a vaild buffer input stream pointer.' assert * > bufferInputStreamPtr
removeObject bufferPtr
e=. initError ''
ret garrow_input_stream_align bufferInputStreamPtr;64;<e
checkError e
bufferInputStreamPtr
}}

recordBatchStreamReaderTable=: {{
bufferInputStreamPtr=. y
'Not a vaild buffer input stream pointer.' assert * > bufferInputStreamPtr
e=. initError ''
streamReaderPtr=. ptr garrow_record_batch_stream_reader_new bufferInputStreamPtr;<e
checkError e
'Not a vaild stream reader pointer.' assert * > streamReaderPtr
e=. initError ''
tablePtr=. ptr garrow_record_batch_reader_read_all streamReaderPtr;<e
checkError e
'Not a vaild table pointer.' assert * > tablePtr
removeObject streamReaderPtr
tablePtr
}}

getRecordBatch=: {{
recordBatchPtr=. y
nCols=. ret garrow_record_batch_get_n_columns < recordBatchPtr
names=. > a:
arrays=. > a:
for_cn. i. nCols do.
  names=. names, < getString ptr garrow_record_batch_get_column_name recordBatchPtr;<cn
  arrayPtr=. ptr garrow_record_batch_get_column_data recordBatchPtr;<cn
  arrays=. arrays , < readArray arrayPtr
  removeObject arrayPtr
end.
NB. names
< ,. each arrays
}}

recordBatchStreamReader=: {{
NB. This will read recordbatches out of a stream file.
filepath=. y
'File does not exist.' assert fexist jpath filepath
inputStreamPtr=. fileInputStream filepath
NB. inputStreamPtr =. memmoryMappedFileInputStream filepath
'Not a vaild inputstream pointer.' assert * > inputStreamPtr
e=. initError ''
ret garrow_input_stream_align inputStreamPtr;64;<e
checkError e
NB. echo ret garrow_seekable_input_stream_get_size fileInputStreamPtr;<e
e=. initError ''
streamReaderPtr=. ptr garrow_record_batch_stream_reader_new inputStreamPtr;<e
checkError e
'Not a valid streamReader.' assert * > streamReaderPtr
NB. schemaPtr =. ptr garrow_record_batch_reader_get_schema <streamReaderPtr
NB. readOptionsPtr =. makeReadOptions''
NB. 'Not a valid schema.' assert * > schemaPtr
NB. recordBatchPtr =. ptr garrow_input_stream_read_record_batch fileInputStreamPtr;schemaPtr;readOptionsPtr;<e
res=. > a:
e=. initError ''
recordBatchPtr=. [ptr garrow_record_batch_reader_read_next streamReaderPtr;<e
checkError e
while. > recordBatchPtr do.
  res=. res, getRecordBatch recordBatchPtr
  removeObject recordBatchPtr
  e=. initError ''
  recordBatchPtr=. [ptr garrow_record_batch_reader_read_next streamReaderPtr;<e
  checkError e
end.
removeObject inputStreamPtr
removeObject streamReaderPtr
res
}}

NB. IPC format for saved files (.arrow file)
readArrowTable=. readIPCTable=. recordBatchTable@recordBatchFileReader
NB. IPC format for streaming, but from a file on disk (.arrows file)
readFileBufferTable=. readArrowsTable=. readIPCFileStreamTable=. fileInputStreamTable
NB. ====================
NB. Expose public interface in z locale

transfers=. 0 : 0
printTableSchema
readTableNames
readTableSchema
readTableColName

readArrowTable
readFileBufferTable
readBufferTable

readParquetSchema
printParquetSchema
readParquetData
readParquetTable
readsParquetTable
readParquetDataframe
readParquetCol

readFeatherSchema
printFeatherSchema
readFeatherData
readFeatherTable
readsFeatherTable
readFeatherDataframe
readFeatherCol

readCSVSchema
printCSVSchema
readCSVData
readCSVTable
readsCSVTable
readCSVDataframe
readCSVCol

readJsonSchema
printJsonSchema
readJsonData
readJsonTable
readsJsonTable
readJsonDataframe
readJsonCol

readFeatherSchema
printFeatherSchema
readFeatherData
readFeatherTable
readsFeatherTable
readFeatherDataframe
readFeatherCol
)

localemover =. ((,&'_parrow_')@[  (],(' =: '&,)@[)   (,&'_z_')@])
move =. (".@localemover@deb each)@(LF&cut) 
1 [ move transfers
