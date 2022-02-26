NB. init

lib =: >@((3&{.)@(TAB&cut)&.>)@(LF&cut)
ret =: 0&{::
ptr =: <@(0&{::)
getChar =: {{memr (>y),0,_1,2}}
getCharFree =: {{res [ memf y [ res=.memr (y=.>y),0,_1,2}}
setChar =: {{p [ y memw p,0,(# y),2 [ p=.mema # y=.(>y),{.a.}}

libload =: {{
  if.     UNAME-:'Linux' do.
    libParquet =: '/lib/x86_64-linux-gnu/libparquet-glib.so'
    libArrow   =: '/lib/x86_64-linux-gnu/libarrow-glib.so'
  elseif. UNAME-:'Darwin' do.
    libParquet =: '"','" ',~  '/usr/local/lib/libparquet-glib.dylib'
    libArrow   =: '"','" ',~  '/usr/local/lib/libarrow-glib.dylib'
  elseif. UNAME-:'Win' do.
    libParquet =: '"','" ',~  'C:/msys64/mingqw64/bin/libparquet-glib-400.dll'
    libArrow   =: '"','" ',~  'C:/msys64/mingqw64/bin/libarrow-glib-400.dll'
  end.
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

  >./ libParquet cbind parquetReaderBindings, parquetWriterBindings
  >./ libArrow cbind tableBindings, recordBatchBindings, chunkedArrayBindings
  >./ libArrow cbind basicArrayBindings, compositeArrayBindings
  >./ libArrow cbind schemaBindings, fieldBindings
  >./ libArrow cbind basicDatatypeBindings, compositeDataTypeBindings
  >./ libArrow cbind basicArrayBindings,compositeArrayBindings
  >./ libArrow cbind bufferBindings
  >./ libArrow cbind ipcOptionsBindings,readerBindings,orcFileReaderBindings,writerBindings

  1
}}
NB. =========================================================
NB. Basic Array
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/basic-array-classes.html
NB. =========================================================

basicArrayBindings =: lib 0 : 0
c * *	garrow_array_equal	(GArrowArray *array, GArrowArray *other_array); gboolean
c * * *	garrow_array_equal_options	(GArrowArray *array, GArrowArray *other_array, GArrowEqualOptions *options); gboolean
c * *	garrow_array_equal_approx	(GArrowArray *array, GArrowArray *other_array); gboolean
c * x * x x *	garrow_array_equal_range	(GArrowArray *array, gint64 start_index, GArrowArray *other_array, gint64 other_start_index, gint64 end_index, GArrowEqualOptions *options); gboolean
c * x	garrow_array_is_null	(GArrowArray *array, gint64 i); gboolean
c * x	garrow_array_is_valid	(GArrowArray *array, gint64 i); gboolean
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
n *	garrow_null_array_init	(GArrowNullArray *object); static void
n *	garrow_null_array_class_init	(GArrowNullArrayClass *klass); static void
* x * * x	garrow_primitive_array_new	(gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowArray *
* * x * * x	garrow_primitive_array_new	(GArrowDataType *data_type, gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowArray *
n *	garrow_primitive_array_init	(GArrowPrimitiveArray *object); static void
n *	garrow_primitive_array_class_init	(GArrowPrimitiveArrayClass *klass); static void
* *	garrow_primitive_array_get_data_buffer	(GArrowPrimitiveArray *array); GArrowBuffer *
n *	garrow_boolean_array_init	(GArrowBooleanArray *object); static void
n *	garrow_boolean_array_class_init	(GArrowBooleanArrayClass *klass); static void
*c x * * x	garrow_boolean_array_new	(gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowBooleanArray *
c * x	garrow_boolean_array_get_value	(GArrowBooleanArray *array, gint64 i); gboolean
*c * *	garrow_boolean_array_get_values	(GArrowBooleanArray *array, gint64 *length); gboolean *
n *	garrow_numeric_array_init	(GArrowNumericArray *object); static void
n *	garrow_numeric_array_class_init	(GArrowNumericArrayClass *klass); static void
n *	garrow_int8_array_init	(GArrowInt8Array *object); static void
n *	garrow_int8_array_class_init	(GArrowInt8ArrayClass *klass); static void
* x * * x	garrow_int8_array_new	(gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowInt8Array *
*l * x	garrow_int8_array_get_value	(GArrowInt8Array *array, gint64 i); gint8
*l * *x	garrow_int8_array_get_values	(GArrowInt8Array *array, gint64 *length); const gint8 *
n *	garrow_uint8_array_init	(GArrowUInt8Array *object); static void
n *	garrow_uint8_array_class_init	(GArrowUInt8ArrayClass *klass); static void
* x * * x	garrow_uint8_array_new	(gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowUInt8Array *
l * x	garrow_uint8_array_get_value	(GArrowUInt8Array *array, gint64 i); guint8
*l *i *x	garrow_uint8_array_get_values	(GArrowUInt8Array *array, gint64 *length); const guint8 *
n *	garrow_int16_array_init	(GArrowInt16Array *object); static void
n *	garrow_int16_array_class_init	(GArrowInt16ArrayClass *klass); static void
* * * x	garrow_int16_array_new	(gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowInt16Array *
i * x	garrow_int16_array_get_value	(GArrowInt16Array *array, gint64 i); gint16  NB. FIX
* * *	garrow_int16_array_get_values	(GArrowInt16Array *array, gint64 *length); const gint16 *
n *	garrow_uint16_array_init	(GArrowUInt16Array *object); static void  NB. FIX
n *	garrow_uint16_array_class_init	(GArrowUInt16ArrayClass *klass); static void  NB. FIX
* x * * x	garrow_uint16_array_new	(gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowUInt16Array *  NB. FIX
i * x	garrow_uint16_array_get_value	(GArrowUInt16Array *array, gint64 i); guint16  NB. FIX
* * *	garrow_uint16_array_get_values	(GArrowUInt16Array *array, gint64 *length); const guint16 *  NB. FIX
n *	garrow_int32_array_init	(GArrowInt32Array *object); static void
n *	garrow_int32_array_class_init	(GArrowInt32ArrayClass *klass); static void
i x * * x	garrow_int32_array_new	(gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowInt32Array *
i * x	garrow_int32_array_get_value	(GArrowInt32Array *array, gint64 i); gint32
*i * *x	garrow_int32_array_get_values	(GArrowInt32Array *array, gint64 *length); const gint32 *
n *	garrow_uint32_array_init	(GArrowUInt32Array *object); static void
n *	garrow_uint32_array_class_init	(GArrowUInt32ArrayClass *klass); static void
* x * * x	garrow_uint32_array_new	(gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowUInt32Array *
i * x	garrow_uint32_array_get_value	(GArrowUInt32Array *array, gint64 i); guint32
*i * *x	garrow_uint32_array_get_values	(GArrowUInt32Array *array, gint64 *length); const guint32 *
n *	garrow_int64_array_init	(GArrowInt64Array *object); static void
n *	garrow_int64_array_class_init	(GArrowInt64ArrayClass *klass); static void
*x x * * x	garrow_int64_array_new	(gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowInt64Array *
x * x	garrow_int64_array_get_value	(GArrowInt64Array *array, gint64 i); gint64
*x * *x	garrow_int64_array_get_values	(GArrowInt64Array *array, gint64 *length); const gint64 *
n *	garrow_uint64_array_init	(GArrowUInt64Array *object); static void
n *	garrow_uint64_array_class_init	(GArrowUInt64ArrayClass *klass); static void
*x x * * x	garrow_uint64_array_new	(gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowUInt64Array *
x * x	garrow_uint64_array_get_value	(GArrowUInt64Array *array, gint64 i); guint64
*x * *x	garrow_uint64_array_get_values	(GArrowUInt64Array *array, gint64 *length); const guint64 *
n *	garrow_float_array_init	(GArrowFloatArray *object); static void
n *	garrow_float_array_class_init	(GArrowFloatArrayClass *klass); static void
* x * * x	garrow_float_array_new	(gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowFloatArray *
d * x	garrow_float_array_get_value	(GArrowFloatArray *array, gint64 i); gfloat
*d * *x	garrow_float_array_get_values	(GArrowFloatArray *array, gint64 *length); const gfloat *
n *	garrow_double_array_init	(GArrowDoubleArray *object); static void
n *	garrow_double_array_class_init	(GArrowDoubleArrayClass *klass); static void
* x * * x	garrow_double_array_new	(gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowDoubleArray *
d * x	garrow_double_array_get_value	(GArrowDoubleArray *array, gint64 i); gdouble
*d * *x	garrow_double_array_get_values	(GArrowDoubleArray *array, gint64 *length); const gdouble *
* x * * * x	garrow_base_binary_array_new	(gint64 length, GArrowBuffer *value_offsets, GArrowBuffer *value_data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowArray *
* * x	garrow_base_binary_array_get_value	(GArrowArray *array, gint64 i); GBytes *
* *	garrow_base_binary_array_get_data_buffer	(GArrowArray *array); GArrowBuffer *
* *	garrow_base_binary_array_get_offsets_buffer	(GArrowArray *array); GArrowBuffer *
n *	garrow_binary_array_init	(GArrowBinaryArray *object); static void
n *	garrow_binary_array_class_init	(GArrowBinaryArrayClass *klass); static void
* x * * * x	garrow_binary_array_new	(gint64 length, GArrowBuffer *value_offsets, GArrowBuffer *value_data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowBinaryArray *
* * x	garrow_binary_array_get_value	(GArrowBinaryArray *array, gint64 i); GBytes *
* *	garrow_binary_array_get_buffer	(GArrowBinaryArray *array); GArrowBuffer *
* *	garrow_binary_array_get_data_buffer	(GArrowBinaryArray *array); GArrowBuffer *
* *	garrow_binary_array_get_offsets_buffer	(GArrowBinaryArray *array); GArrowBuffer *
x *	garrow_large_binary_array_init	(GArrowLargeBinaryArray *object); static void
n *	garrow_large_binary_array_class_init	(GArrowLargeBinaryArrayClass *klass); static void
* x * * * x	garrow_large_binary_array_new	(gint64 length, GArrowBuffer *value_offsets, GArrowBuffer *value_data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowLargeBinaryArray *
* * x	garrow_large_binary_array_get_value	(GArrowLargeBinaryArray *array, gint64 i); GBytes *
* *	garrow_large_binary_array_get_buffer	(GArrowLargeBinaryArray *array); GArrowBuffer *
* *	garrow_large_binary_array_get_data_buffer	(GArrowLargeBinaryArray *array); GArrowBuffer *
* *	garrow_large_binary_array_get_offsets_buffer	(GArrowLargeBinaryArray *array); GArrowBuffer *
*c * x	garrow_base_string_array_get_value	(GArrowArray *array, gint64 i); gchar *
n *	garrow_string_array_init	(GArrowStringArray *object); static void
n *	garrow_string_array_class_init	(GArrowStringArrayClass *klass); static void
* x * * * x	garrow_string_array_new	(gint64 length, GArrowBuffer *value_offsets, GArrowBuffer *value_data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowStringArray *
*c * x	garrow_string_array_get_string	(GArrowStringArray *array, gint64 i); gchar *
n *	garrow_large_string_array_init	(GArrowLargeStringArray *object); static void
n *	garrow_large_string_array_class_init	(GArrowLargeStringArrayClass *klass); static void
* x * * * x	garrow_large_string_array_new	(gint64 length, GArrowBuffer *value_offsets, GArrowBuffer *value_data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowLargeStringArray *
* * x	garrow_large_string_array_get_string	(GArrowLargeStringArray *array, gint64 i); gchar *
n *	garrow_date32_array_init	(GArrowDate32Array *object); static void
n *	garrow_date32_array_class_init	(GArrowDate32ArrayClass *klass); static void
* x * * x	garrow_date32_array_new	(gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowDate32Array *
i * x	garrow_date32_array_get_value	(GArrowDate32Array *array, gint64 i); gint32
*i * *x	garrow_date32_array_get_values	(GArrowDate32Array *array, gint64 *length); const gint32 *
n * 	garrow_date64_array_init	(GArrowDate64Array *object); static void
n *	garrow_date64_array_class_init	(GArrowDate64ArrayClass *klass); static void
* x * * x	garrow_date64_array_new	(gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowDate64Array *
x * x	garrow_date64_array_get_value	(GArrowDate64Array *array, gint64 i); gint64
*x * *x	garrow_date64_array_get_values	(GArrowDate64Array *array, gint64 *length); const gint64 *
n *	garrow_timestamp_array_init	(GArrowTimestampArray *object); static void
n *	garrow_timestamp_array_class_init	(GArrowTimestampArrayClass *klass); static void
* * x * * x	garrow_timestamp_array_new	(GArrowTimestampDataType *data_type, gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowTimestampArray *
x * x	garrow_timestamp_array_get_value	(GArrowTimestampArray *array, gint64 i); gint64
*x * *x	garrow_timestamp_array_get_values	(GArrowTimestampArray *array, gint64 *length); const gint64 *
n *	garrow_time32_array_init	(GArrowTime32Array *object); static void
n *	garrow_time32_array_class_init	(GArrowTime32ArrayClass *klass); static void
*i * x * * x	garrow_time32_array_new	(GArrowTime32DataType *data_type, gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowTime32Array *
i * x	garrow_time32_array_get_value	(GArrowTime32Array *array, gint64 i); gint32
*i * *x	garrow_time32_array_get_values	(GArrowTime32Array *array, gint64 *length); const gint32 *
n *	garrow_time64_array_init	(GArrowTime64Array *object); static void
n *	garrow_time64_array_class_init	(GArrowTime64ArrayClass *klass); static void
*x * x * * x	garrow_time64_array_new	(GArrowTime64DataType *data_type, gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowTime64Array *
x *x x	garrow_time64_array_get_value	(GArrowTime64Array *array, gint64 i); gint64
*x * x	garrow_time64_array_get_values	(GArrowTime64Array *array, gint64 *length); const gint64 *
n *	garrow_fixed_size_binary_array_init	(GArrowFixedSizeBinaryArray *object); static void
n *	garrow_fixed_size_binary_array_class_init	(GArrowFixedSizeBinaryArrayClass *klass); static void
* * x * * x	garrow_fixed_size_binary_array_new	(GArrowFixedSizeBinaryDataType *data_type, gint64 length, GArrowBuffer *data, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowFixedSizeBinaryArray *
i *	garrow_fixed_size_binary_array_get_byte_width	(GArrowFixedSizeBinaryArray *array); gint32
* * x	garrow_fixed_size_binary_array_get_value	(GArrowFixedSizeBinaryArray *array, gint64 i); GBytes *
* *	garrow_fixed_size_binary_array_get_values_bytes	(GArrowFixedSizeBinaryArray *array); GBytes *
n *	garrow_decimal128_array_init	(GArrowDecimal128Array *object); static void
n *	garrow_decimal128_array_class_init	(GArrowDecimal128ArrayClass *klass); static void
*c * x	garrow_decimal128_array_format_value	(GArrowDecimal128Array *array, gint64 i); gchar *
* * x	garrow_decimal128_array_get_value	(GArrowDecimal128Array *array, gint64 i); GArrowDecimal128 *
n *	garrow_decimal256_array_init	(GArrowDecimal256Array *object); static void
n *	garrow_decimal256_array_class_init	(GArrowDecimal256ArrayClass *klass); static void
*c * x	garrow_decimal256_array_format_value	(GArrowDecimal256Array *array, gint64 i); gchar *
* * x	garrow_decimal256_array_get_value	(GArrowDecimal256Array *array, gint64 i); GArrowDecimal256 *
)

NB. =========================================================
NB. Composite Array
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/composite-array-classes.html
NB. =========================================================

compositeArrayBindings =: lib 0 : 0
* * x * * * x	garrow_base_list_array_new	(GArrowDataType *data_type, gint64 length, GArrowBuffer *value_offsets, GArrowArray *values, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowArray *
* *	garrow_base_list_array_get_value_type	(GArrowArray *array); GArrowDataType *
* * x	garrow_base_list_array_get_value	(GArrowArray *array , gint64 i); GArrowArray *
* *	garrow_base_list_array_get_values	(GArrowArray *array); GArrowArray *
c i x	garrow_base_list_array_get_value_offset	(GArrowArray *array, gint64 i); typename LIST_ARRAY_CLASS::offset_type
c * x	garrow_base_list_array_get_value_length	(GArrowArray *array, gint64 i); typename LIST_ARRAY_CLASS::offset_type
*c * *x	garrow_base_list_array_get_value_offsets	(GArrowArray *array, gint64 *n_offsets); const typename LIST_ARRAY_CLASS::offset_type *
n *	garrow_list_array_dispose	(GObject *object); static void
n * i * *	garrow_list_array_set_property	(GObject *object, guint prop_id, const GValue *value, GParamSpec *pspec); static void
n * i * *	garrow_list_array_get_property	(GObject *object, guint prop_id, GValue *value, GParamSpec *pspec); static void
n *	garrow_list_array_init	(GArrowListArray *object); static void
n *	garrow_list_array_class_init	(GArrowListArrayClass *klass); static void
* * x * * * * x	garrow_list_array_new	(GArrowDataType *data_type, gint64 length, GArrowBuffer *value_offsets, GArrowArray *values, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowListArray *
* *	garrow_list_array_get_value_type	(GArrowListArray *array); GArrowDataType *
* * x	garrow_list_array_get_value	(GArrowListArray *array, gint64 i); GArrowArray *
* *	garrow_list_array_get_values	(GArrowListArray *array); GArrowArray *
i * x	garrow_list_array_get_value_offset	(GArrowListArray *array, gint64 i); gint32
i * x	garrow_list_array_get_value_length	(GArrowListArray *array, gint64 i); gint32
*i * x	garrow_list_array_get_value_offsets	(GArrowListArray *array, gint64 *n_offsets); const gint32 *
n *	garrow_large_list_array_dispose	(GObject *object); static void
n * i * *	garrow_large_list_array_set_property	(GObject *object, guint prop_id, const GValue *value, GParamSpec *pspec); static void
n * i * *	garrow_large_list_array_get_property	(GObject *object, guint prop_id, GValue *value, GParamSpec *pspec); static void
n *	garrow_large_list_array_init	(GArrowLargeListArray *object); static void
n *	garrow_large_list_array_class_init	(GArrowLargeListArrayClass *klass); static void
* * i * * * x	garrow_large_list_array_new	(GArrowDataType *data_type, gint64 length, GArrowBuffer *value_offsets, GArrowArray *values, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowLargeListArray *
* *	garrow_large_list_array_get_value_type	(GArrowLargeListArray *array); GArrowDataType *
* * x	garrow_large_list_array_get_value	(GArrowLargeListArray *array , gint64 i); GArrowArray *
* *	garrow_large_list_array_get_values	(GArrowLargeListArray *array); GArrowArray *
x * x	garrow_large_list_array_get_value_offset	(GArrowLargeListArray *array, gint64 i); gint64
x * x	garrow_large_list_array_get_value_length	(GArrowLargeListArray *array, gint64 i); gint64
*x * *x	garrow_large_list_array_get_value_offsets	(GArrowLargeListArray *array, gint64 *n_offsets); const gint64 *
n *	garrow_struct_array_dispose	(GObject *object); static void
n *	garrow_struct_array_init	(GArrowStructArray *object); static void
n *	garrow_struct_array_class_init	(GArrowStructArrayClass *klass); static void
* * x * * x	garrow_struct_array_new	(GArrowDataType *data_type, gint64 length, GList *fields, GArrowBuffer *null_bitmap, gint64 n_nulls); GArrowStructArray *
* *	garrow_struct_array_get_fields_internal	(GArrowStructArray *array); static GPtrArray *
* * i	garrow_struct_array_get_field	(GArrowStructArray *array, gint i); GArrowArray *
* *	garrow_struct_array_get_fields	(GArrowStructArray *array) GList *
* * *	garrow_struct_array_flatten	(GArrowStructArray *array, GError **error); GList *
n *	garrow_map_array_dispose	(GObject *object); static void
n * i * * 	garrow_map_array_set_property	(GObject *object, guint prop_id, const GValue *value, GParamSpec *pspec); static void
n * i * * 	garrow_map_array_get_property	(GObject *object, guint prop_id, GValue *value, GParamSpec *pspec); static void
n *	garrow_map_array_init	(GArrowMapArray *object); static void
n * 	garrow_map_array_class_init	(GArrowMapArrayClass *klass); static void
* * * * * 	garrow_map_array_new	(GArrowArray *offsets, GArrowArray *keys, GArrowArray *items, GError **error); GArrowMapArray *
* *	garrow_map_array_get_keys	(GArrowMapArray *array); GArrowArray *
* *	garrow_map_array_get_items	(GArrowMapArray *array); GArrowArray *
n *	garrow_union_array_dispose	(GObject *object); static void
n * i * *	garrow_union_array_set_property	(GObject *object, guint prop_id, const GValue *value, GParamSpec *pspec); static void
n * i * *	garrow_union_array_get_property	(GObject *object, guint prop_id, GValue *value, GParamSpec *pspec); static void
n *	garrow_union_array_init	(GArrowUnionArray *object); static void
n * 	garrow_union_array_class_init	(GArrowUnionArrayClass *klass); static void
* * i	garrow_union_array_get_field	(GArrowUnionArray *array, gint i); GArrowArray *
n *	garrow_sparse_union_array_init	(GArrowSparseUnionArray *object); static void
n *	garrow_sparse_union_array_class_init	(GArrowSparseUnionArrayClass *klass); static void
* * * * * *	garrow_sparse_union_array_new_internal	(GArrowSparseUnionDataType *data_type, GArrowInt8Array *type_ids, GList *fields, GError **error, const char *context); static GArrowSparseUnionArray *
* * * *	garrow_sparse_union_array_new	(GArrowInt8Array *type_ids, GList *fields, GError **error); GArrowSparseUnionArray *
* * * * 	garrow_sparse_union_array_new_data_type	(GArrowSparseUnionDataType *data_type, GArrowInt8Array *type_ids, GList *fields, GError **error); GArrowSparseUnionArray *
n *	garrow_dense_union_array_dispose	(GObject *object); static void
n * i * *	garrow_dense_union_array_set_property	(GObject *object, guint prop_id, const GValue *value, GParamSpec *pspec); static void
n * i *	garrow_dense_union_array_get_property	(GObject *object, guint prop_id, GValue *value, GParamSpec *pspec); static void
n *	garrow_dense_union_array_init	(GArrowDenseUnionArray *object); static void
n *	garrow_dense_union_array_class_init	(GArrowDenseUnionArrayClass *klass); static void
* * * * * * *c	garrow_dense_union_array_new_internal	(GArrowDenseUnionDataType *data_type, GArrowInt8Array *type_ids, GArrowInt32Array *value_offsets, GList *fields, GError **error, const gchar *context); static GArrowDenseUnionArray *
* * * * *	garrow_dense_union_array_new	(GArrowInt8Array *type_ids, GArrowInt32Array *value_offsets, GList *fields, GError **error); GArrowDenseUnionArray *
* * * * * *	garrow_dense_union_array_new_data_type	(GArrowDenseUnionDataType *data_type, GArrowInt8Array *type_ids, GArrowInt32Array *value_offsets, GList *fields, GError **error); GArrowDenseUnionArray *
n *	garrow_dictionary_array_dispose	(GObject *object); static void
n * i * * 	garrow_dictionary_array_set_property	(GObject *object, guint prop_id, const GValue *value, GParamSpec *pspec); static void
n * i * *	garrow_dictionary_array_get_property	(GObject *object, guint prop_id, GValue *value, GParamSpec *pspec); static void
n *	garrow_dictionary_array_init	(GArrowDictionaryArray *object); static void
n *	garrow_dictionary_array_class_init	(GArrowDictionaryArrayClass *klass); static void
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
c * *	garrow_buffer_equal	(GArrowBuffer *buffer, GArrowBuffer *other_buffer); gboolean
c * * i	garrow_buffer_equal_n_bytes	(GArrowBuffer *buffer, GArrowBuffer *other_buffer, gint64 n_bytes); gboolean
c *	garrow_buffer_is_mutable	(GArrowBuffer *buffer); gboolean
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
c * i *i i *	garrow_mutable_buffer_set_data	(GArrowMutableBuffer *buffer, gint64 offset, const guint8 *data, gint64 size, GError **error); gboolean
n *	garrow_resizable_buffer_init	(GArrowResizableBuffer *object); static void
n *	garrow_resizable_buffer_class_init	(GArrowResizableBufferClass *klass); static void
* i *	garrow_resizable_buffer_new	(gint64 initial_size, GError **error); GArrowResizableBuffer *
c * i *	garrow_resizable_buffer_resize	(GArrowResizableBuffer *buffer, gint64 new_size, GError **error); gboolean
c * i *	garrow_resizable_buffer_reserve	(GArrowResizableBuffer *buffer, gint64 new_capacity, GError **error); gboolean
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
ADD TYPES
garrow_codec_finalize(GObject *object); static void
garrow_codec_set_property(GObject *object, guint prop_id, const GValue *value, GParamSpec *pspec); static void
garrow_codec_get_property(GObject *object, guint prop_id, GValue *value, GParamSpec *pspec); static void
garrow_codec_init(GArrowCodec *object); static void
garrow_codec_class_init(GArrowCodecClass *klass); static void
garrow_codec_new(GArrowCompressionType type, GError **error); GArrowCodec *
garrow_codec_get_name(GArrowCodec *codec); const gchar *
garrow_codec_get_compression_type(GArrowCodec *codec); GArrowCompressionType
garrow_codec_get_compression_level(GArrowCodec *codec); gint
garrow_compression_type_from_raw(arrow::Compression::type arrow_type); ArrowCompressionType
garrow_compression_type_to_raw(GArrowCompressionType type)}; arrow::Compression::type
garrow_codec_new_raw(std::shared_ptr<arrow::util::Codec> *arrow_codec); GArrowCodec *
garrow_codec_get_raw(GArrowCodec *codec); std::shared_ptr<arrow::util::Codec>
)
NB. =========================================================
NB. Basic Data Type
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/basic-data-type-classes.html
NB. =========================================================

basicDatatypeBindings =: lib 0 : 0
n *	garrow_data_type_finalize	(GObject *object); static void
n * i * *	garrow_data_type_set_property	(GObject *object, guint prop_id, const GValue *value, GParamSpec *pspec); static void
n * i * *	garrow_data_type_get_property	(GObject *object, guint prop_id, GValue *value, GParamSpec *pspec); static void
n *	garrow_data_type_init	(GArrowDataType *object); static void
n *	garrow_data_type_class_init	(GArrowDataTypeClass *klass); static void
c * *	garrow_data_type_equal	(GArrowDataType *data_type, GArrowDataType *other_data_type); gboolean
*c *	garrow_data_type_to_string	(GArrowDataType *data_type); gchar *
i *	garrow_data_type_get_id	(GArrowDataType *data_type); GArrowType
*c *	garrow_data_type_get_name	(GArrowDataType *data_type); gchar *
n *	garrow_fixed_width_data_type_init	(GArrowFixedWidthDataType *object); static void
n *	garrow_fixed_width_data_type_class_init	(GArrowFixedWidthDataTypeClass *klass); static void
i *	garrow_fixed_width_data_type_get_bit_width	(GArrowFixedWidthDataType *data_type); gint
n *	garrow_null_data_type_init	(GArrowNullDataType *object); static void
n *	garrow_null_data_type_class_init	(GArrowNullDataTypeClass *klass); static void
*	garrow_null_data_type_new	(void); GArrowNullDataType *
n *	garrow_boolean_data_type_init	(GArrowBooleanDataType *object); static void
n *	garrow_boolean_data_type_class_init	(GArrowBooleanDataTypeClass *klass); static void
*	garrow_boolean_data_type_new	(void); GArrowBooleanDataType *
n *	garrow_numeric_data_type_init	(GArrowNumericDataType *object); static void
n *	garrow_numeric_data_type_class_init	(GArrowNumericDataTypeClass *klass); static void
n *	garrow_integer_data_type_init	(GArrowIntegerDataType *object); static void
n *	garrow_integer_data_type_class_init	(GArrowIntegerDataTypeClass *klass); static void
c *	garrow_integer_data_type_is_signed	(GArrowIntegerDataType *data_type); gboolean
n *	garrow_int8_data_type_init	(GArrowInt8DataType *object); static void
n *	garrow_int8_data_type_class_init	(GArrowInt8DataTypeClass *klass); static void
*	garrow_int8_data_type_new	(void);GArrowInt8DataType *
n *	garrow_uint8_data_type_init	(GArrowUInt8DataType *object); static void
n *	garrow_uint8_data_type_class_init	(GArrowUInt8DataTypeClass *klass); static void
*	garrow_uint8_data_type_new	(void); GArrowUInt8DataType *
n *	garrow_int16_data_type_init	(GArrowInt16DataType *object); static void
n *	garrow_int16_data_type_class_init	(GArrowInt16DataTypeClass *klass); static void
*	garrow_int16_data_type_new	(void); GArrowInt16DataType *
n *	garrow_uint16_data_type_init	(GArrowUInt16DataType *object); static void
n *	garrow_uint16_data_type_class_init	(GArrowUInt16DataTypeClass *klass); static void
*	garrow_uint16_data_type_new	(void); GArrowUInt16DataType *
n *	garrow_int32_data_type_init	(GArrowInt32DataType *object); static void
n *	garrow_int32_data_type_class_init	(GArrowInt32DataTypeClass *klass); static void
*	garrow_int32_data_type_new	(void); GArrowInt32DataType *
n *	garrow_uint32_data_type_init	(GArrowUInt32DataType *object); static void
n *	garrow_uint32_data_type_class_init	(GArrowUInt32DataTypeClass *klass); static void
*	garrow_uint32_data_type_new	(void); GArrowUInt32DataType *
n *	garrow_int64_data_type_init	(GArrowInt64DataType *object); static void
n *	garrow_int64_data_type_class_init	(GArrowInt64DataTypeClass *klass); static void
*	garrow_int64_data_type_new	(void); GArrowInt64DataType *
n *	garrow_uint64_data_type_init	(GArrowUInt64DataType *object); static void
n *	garrow_uint64_data_type_class_init	(GArrowUInt64DataTypeClass *klass); static void
*	garrow_uint64_data_type_new	(void); GArrowUInt64DataType *
n *	garrow_floating_point_data_type_init	(GArrowFloatingPointDataType *object); static void
n *	garrow_floating_point_data_type_class_init	(GArrowFloatingPointDataTypeClass *klass); static void
n *	garrow_float_data_type_init	(GArrowFloatDataType *object); static void
n *	garrow_float_data_type_class_init	(GArrowFloatDataTypeClass *klass); static void
*	garrow_float_data_type_new	(void); GArrowFloatDataType *
n *	garrow_double_data_type_init	(GArrowDoubleDataType *object); static void
n *	garrow_double_data_type_class_init	(GArrowDoubleDataTypeClass *klass); static void
*	garrow_double_data_type_new	(void); GArrowDoubleDataType *
n *	garrow_binary_data_type_init	(GArrowBinaryDataType *object); static void
n *	garrow_binary_data_type_class_init	(GArrowBinaryDataTypeClass *klass); static void
*	garrow_binary_data_type_new	(void); GArrowBinaryDataType *
n *	garrow_fixed_size_binary_data_type_init	(GArrowFixedSizeBinaryDataType *object); static void
n *	garrow_fixed_size_binary_data_type_class_init	(GArrowFixedSizeBinaryDataTypeClass *klass); static void
* i	garrow_fixed_size_binary_data_type_new	(gint32 byte_width); GArrowFixedSizeBinaryDataType *
i *	garrow_fixed_size_binary_data_type_get_byte_width	(GArrowFixedSizeBinaryDataType *data_type); gint32
n *	garrow_large_binary_data_type_init	(GArrowLargeBinaryDataType *object); static void
n *	garrow_large_binary_data_type_class_init	(GArrowLargeBinaryDataTypeClass *klass); static void
*	garrow_large_binary_data_type_new	(void); GArrowLargeBinaryDataType *
n *	garrow_string_data_type_init	(GArrowStringDataType *object); static void
n *	garrow_string_data_type_class_init	(GArrowStringDataTypeClass *klass); static void
*	garrow_string_data_type_new	(void); GArrowStringDataType *
n *	garrow_large_string_data_type_init	(GArrowLargeStringDataType *object); static void
n *	garrow_large_string_data_type_class_init	(GArrowLargeStringDataTypeClass *klass); static void
*	garrow_large_string_data_type_new	(void); GArrowLargeStringDataType *
n *	garrow_date32_data_type_init	(GArrowDate32DataType *object); static void
n *	garrow_date32_data_type_class_init	(GArrowDate32DataTypeClass *klass); static void
*	garrow_date32_data_type_new	(void); GArrowDate32DataType *
n *	garrow_date64_data_type_init	(GArrowDate64DataType *object); static void
n *	garrow_date64_data_type_class_init	(GArrowDate64DataTypeClass *klass); static void
*	garrow_date64_data_type_new	(void); GArrowDate64DataType *
n *	garrow_timestamp_data_type_init	(GArrowTimestampDataType *object); static void
n *	garrow_timestamp_data_type_class_init	(GArrowTimestampDataTypeClass *klass); static void
* i	garrow_timestamp_data_type_new	(GArrowTimeUnit unit); GArrowTimestampDataType *
i *	garrow_timestamp_data_type_get_unit	(GArrowTimestampDataType *timestamp_data_type); GArrowTimeUnit
n *	garrow_time_data_type_init	(GArrowTimeDataType *object); static void
n *	garrow_time_data_type_class_init	(GArrowTimeDataTypeClass *klass); static void
i *	garrow_time_data_type_get_unit	(GArrowTimeDataType *time_data_type); GArrowTimeUnit
n *	garrow_time32_data_type_init	(GArrowTime32DataType *object); static void
n *	garrow_time32_data_type_class_init	(GArrowTime32DataTypeClass *klass); static void
* i *	garrow_time32_data_type_new	(GArrowTimeUnit unit, GError **error); GArrowTime32DataType *
n *	garrow_time64_data_type_init	(GArrowTime64DataType *object); static void
n *	garrow_time64_data_type_class_init	(GArrowTime64DataTypeClass *klass); static void
* i *	garrow_time64_data_type_new	(GArrowTimeUnit unit, GError **error); GArrowTime64DataType *
n *	garrow_decimal_data_type_init	(GArrowDecimalDataType *object); static void
n *	garrow_decimal_data_type_class_init	(GArrowDecimalDataTypeClass *klass); static void
* i i	garrow_decimal_data_type_new	(gint32 precision, gint32 scale); GArrowDecimalDataType *
i *	garrow_decimal_data_type_get_precision	(GArrowDecimalDataType *decimal_data_type); gint32
i *	garrow_decimal_data_type_get_scale	(GArrowDecimalDataType *decimal_data_type); gint32
n *	garrow_decimal128_data_type_init	(GArrowDecimal128DataType *object); static void
n *	garrow_decimal128_data_type_class_init	(GArrowDecimal128DataTypeClass *klass); static void
i	garrow_decimal128_data_type_max_precision	(); gint32
* i i	garrow_decimal128_data_type_new	(gint32 precision, gint32 scale); GArrowDecimal128DataType *
n *	garrow_decimal256_data_type_init	(GArrowDecimal256DataType *object); static void
n *	garrow_decimal256_data_type_class_init	(GArrowDecimal256DataTypeClass *klass); static void
i	garrow_decimal256_data_type_max_precision	(); gint32
* i i	garrow_decimal256_data_type_new	(gint32 precision, gint32 scale); GArrowDecimal256DataType *
n *	garrow_extension_data_type_dispose	(GObject *object); static void
n * i * *	garrow_extension_data_type_set_property	(GObject *object, guint prop_id, const GValue *value, GParamSpec *pspec); static void
n * i * *	garrow_extension_data_type_get_property	(GObject *object, guint prop_id, GValue *value, GParamSpec *pspec); static void
n *	garrow_extension_data_type_init	(GArrowExtensionDataType *object); static void
n *	garrow_extension_data_type_class_init	(GArrowExtensionDataTypeClass *klass); static void
*c *	garrow_extension_data_type_get_extension_name	(GArrowExtensionDataType *data_type); gchar *
* * *	garrow_extension_data_type_wrap_array	(GArrowExtensionDataType *data_type, GArrowArray *storage); GArrowExtensionArray *
* * *	garrow_extension_data_type_wrap_chunked_array	(GArrowExtensionDataType *data_type, GArrowChunkedArray *storage); GArrowChunkedArray *
* *	garrow_extension_data_type_get_storage_data_type_raw	(GArrowExtensionDataType *data_type); static std::shared_ptr<arrow::DataType>
n *	garrow_extension_data_type_registry_finalize	(GObject *object); static void
n * i * *	garrow_extension_data_type_registry_set_property	(GObject *object, guint prop_id, const GValue *value, GParamSpec *pspec); static void
n *	garrow_extension_data_type_registry_init	(GArrowExtensionDataTypeRegistry *object); static void
n *	garrow_extension_data_type_registry_class_init	(GArrowExtensionDataTypeRegistryClass *klass); static void
*	garrow_extension_data_type_registry_default	(void); GArrowExtensionDataTypeRegistry *
c * * *	garrow_extension_data_type_registry_register	(GArrowExtensionDataTypeRegistry *registry, GArrowExtensionDataType *data_type, GError **error); gboolean
c * *c *	garrow_extension_data_type_registry_unregister	(GArrowExtensionDataTypeRegistry *registry, const gchar *name, GError **error); gboolean
* * *c	garrow_extension_data_type_registry_lookup	(GArrowExtensionDataTypeRegistry *registry, const gchar *name); GArrowExtensionDataType *
* *	garrow_data_type_new_raw	(std::shared_ptr<arrow::DataType> *arrow_data_type); ArrowDataType *
* *	garrow_data_type_get_raw	(GArrowDataType *data_type); std::shared_ptr<arrow::DataType>
* *	garrow_extension_data_type_registry_new_raw	(std::shared_ptr<arrow::ExtensionTypeRegistry> *arrow_registry); GArrowExtensionDataTypeRegistry *
* *	garrow_extension_data_type_registry_get_raw	( GArrowExtensionDataTypeRegistry *registry); std::shared_ptr<arrow::ExtensionTypeRegistry>
)


NB. =========================================================
NB. Composite Data Type
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/composite-data-type-classes.html
NB. =========================================================

compositeDataTypeBindings =: lib 0 : 0
n *	garrow_list_data_type_init	(GArrowListDataType *object); static void
n *	garrow_list_data_type_class_init	(GArrowListDataTypeClass *klass); static void
* *	garrow_list_data_type_new	(GArrowField *field); GArrowListDataType *
* *	garrow_list_data_type_get_value_field	(GArrowListDataType *list_data_type); GArrowField *
* *	garrow_list_data_type_get_field	(GArrowListDataType *list_data_type); GArrowField *
n *	garrow_large_list_data_type_init	(GArrowLargeListDataType *object); static void
n *	garrow_large_list_data_type_class_init	(GArrowLargeListDataTypeClass *klass); static void
* *	garrow_large_list_data_type_new	(GArrowField *field); GArrowLargeListDataType *
* *	garrow_large_list_data_type_get_field	(GArrowLargeListDataType *large_list_data_type); GArrowField *
n *	garrow_struct_data_type_init	(GArrowStructDataType *object); static void
n *	garrow_struct_data_type_class_init	(GArrowStructDataTypeClass *klass); static void
* *	garrow_struct_data_type_new	(GList *fields); GArrowStructDataType *
i *	garrow_struct_data_type_get_n_fields	(GArrowStructDataType *struct_data_type); gint
* *	garrow_struct_data_type_get_fields	(GArrowStructDataType *struct_data_type); GList *
* * i	garrow_struct_data_type_get_field	(GArrowStructDataType *struct_data_type , gint i); GArrowField *
* * *c	garrow_struct_data_type_get_field_by_name	(GArrowStructDataType *struct_data_type, const gchar *name); GArrowField *
i * *c	garrow_struct_data_type_get_field_index	(GArrowStructDataType *struct_data_type, const gchar *name); gint
n *	garrow_map_data_type_init	(GArrowMapDataType *object); static void
n *	garrow_map_data_type_class_init	(GArrowMapDataTypeClass *klass); static void
* * *	garrow_map_data_type_new	(GArrowDataType *key_type, GArrowDataType *item_type); GArrowMapDataType *
* *	garrow_map_data_type_get_key_type	(GArrowMapDataType *map_data_type); GArrowDataType *
* *	garrow_map_data_type_get_item_type	(GArrowMapDataType *map_data_type); GArrowDataType *
n *	garrow_union_data_type_init	(GArrowUnionDataType *object); static void
n *	garrow_union_data_type_class_init	(GArrowUnionDataTypeClass *klass); static void
i *	garrow_union_data_type_get_n_fields	(GArrowUnionDataType *union_data_type); gint
* *	garrow_union_data_type_get_fields	(GArrowUnionDataType *union_data_type); GList *
* * i	garrow_union_data_type_get_field	(GArrowUnionDataType *union_data_type , gint i); GArrowField *
* * *	garrow_union_data_type_get_type_codes	(GArrowUnionDataType *union_data_type, gsize *n_type_codes); gint8 *
n *	garrow_sparse_union_data_type_init	(GArrowSparseUnionDataType *object); static void
n *	garrow_sparse_union_data_type_class_init	(GArrowSparseUnionDataTypeClass *klass); static void
* * * i	garrow_sparse_union_data_type_new	(GList *fields , gint8 *type_codes , gsize n_type_codes); GArrowSparseUnionDataType *
n *	garrow_dense_union_data_type_init	(GArrowDenseUnionDataType *object); static void
n *	garrow_dense_union_data_type_class_init	(GArrowDenseUnionDataTypeClass *klass); static void
* * * i	garrow_dense_union_data_type_new	(GList *fields , gint8 *type_codes , gsize n_type_codes); GArrowDenseUnionDataType *
n *	garrow_dictionary_data_type_init	(GArrowDictionaryDataType *object); static void
n *	garrow_dictionary_data_type_class_init	(GArrowDictionaryDataTypeClass *klass); static void
* * * c	garrow_dictionary_data_type_new	(GArrowDataType *index_data_type, GArrowDataType *value_data_type, gboolean ordered); GArrowDictionaryDataType *
* *	garrow_dictionary_data_type_get_index_data_type	(GArrowDictionaryDataType *dictionary_data_type); GArrowDataType *
* *	garrow_dictionary_data_type_get_value_data_type	(GArrowDictionaryDataType *dictionary_data_type); GArrowDataType *
c *	garrow_dictionary_data_type_is_ordered	(GArrowDictionaryDataType *dictionary_data_type); gboolean
)
NB. =========================================================
NB. Error
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/arrow-glib-GArrowError.html
NB. =========================================================
errorBindings =: lib 0 : 0
ADD TYPES
garrow_error_check(GError **error, const arrow::Status &status, const char *context); boolean
garrow_error_from_status(const arrow::Status &status); GArrowError
garrow_error_to_status_code(GError *error, arrow::StatusCode default_code); arrow::StatusCode
garrow_error_to_status(GError *error, arrow::StatusCode default_code, const char *context); arrow::Status
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
n * c	gparquet_arrow_file_reader_set_use_threads	(GParquetArrowFileReader *reader, gboolean use_threads); void
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
c * *	gparquet_writer_properties_is_dictionary_enabled	(GParquetWriterProperties *properties, const gchar *path); gboolean
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
c * * x *	gparquet_arrow_file_writer_write_table	(GParquetArrowFileWriter *writer, GArrowTable *table, guint64 chunk_size, GError **error); gboolean
c * *	gparquet_arrow_file_writer_close	(GParquetArrowFileWriter *writer, GError **error); gboolean
)

NB. =========================================================
NB. ArrowSchema
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/GArrowSchema.html

schemaBindings =: lib 0 : 0
* *	garrow_schema_new	(GList *fields); GArrowSchema *
c * *	garrow_schema_equal	(GArrowSchema *schema, GArrowSchema *other_schema); gboolean         
* * i	garrow_schema_get_field	(GArrowSchema *schema, guint i); GArrowField *
* * *	garrow_schema_get_field_by_name	(GArrowSchema *schema,const gchar *name); GArrowField *
i * *	garrow_schema_get_field_index	(GArrowSchema *schema,const gchar *name); gint
i *	garrow_schema_n_fields	(GArrowSchema *schema); guint
* *	garrow_schema_get_fields	(GArrowSchema *schema); GList *
* *	garrow_schema_to_string	(GArrowSchema *schema); gchar *
* * c	garrow_schema_to_string_metadata	(GArrowSchema *schema, gboolean show_metadata); gchar *
* * i * *	garrow_schema_add_field	(GArrowSchema *schema, guint i, GArrowField *field, GError **error); GArrowSchema *
* * i *	garrow_schema_remove_field	(GArrowSchema *schema,guint i, GError **error); GArrowSchema *
* * i * *	garrow_schema_replace_field	(GArrowSchema *schema,guint i, GArrowField *field, GError **error); GArrowSchema *
)


NB. =========================================================
NB. ArrowField
NB. https://arrow.apache.org/docs/c_glib/arrow-glib/GArrowField.html

fieldBindings =: lib 0 : 0
* * *	garrow_field_new	(const gchar *name, GArrowDataType *data_type); GArrowField *
* * * c	garrow_field_new_full	(const gchar *name, GArrowDataType *data_type, gboolean nullable); GArrowField *
* *	garrow_field_get_name	(GArrowField *field); const gchar *
* *	garrow_field_get_data_type	(GArrowField *field); GArrowDataType *
c *	garrow_field_is_nullable	(GArrowField *field); gboolean
c * *	garrow_field_equal	(GArrowField *field, GArrowField *other_field); gboolean
* *	garrow_field_to_string	(GArrowField *field); gchar *
* * c	garrow_field_to_string_metadata	(GArrowField *field, gboolean show_metadata); gchar *
c *	garrow_field_has_metadata	(GArrowField *field); gboolean
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
* * * o *	garrow_table_new_record_batches	(GArrowSchema *schema, GArrowRecordBatch **record_batches, gsize n_record_batches, GError **error); GArrowTable *
c * *	garrow_table_equal	(GArrowTable *table, GArrowTable *other_table); gboolean
c * * c	garrow_table_equal_metadata	(GArrowTable *table, GArrowTable *other_table, gboolean check_metadata); gboolean
* *	garrow_table_get_schema	(GArrowTable *table); GArrowSchema *
* * i	garrow_table_get_column_data	(GArrowTable *table, gint i); GArrowChunkedArray *
i *	garrow_table_get_n_columns	(GArrowTable *table); guint
l *	garrow_table_get_n_rows	(GArrowTable *table); guint64
* * i * * *	garrow_table_add_column	(GArrowTable *table, guint i, GArrowField *field, GArrowChunkedArray *chunked_array, GError **error); GArrowTable *
* * i *	garrow_table_remove_column	(GArrowTable *table, guint i, GError **error); GArrowTable *
* * i * * *	garrow_table_replace_column	(GArrowTable *table, guint i, GArrowField *field, GArrowChunkedArray *chunked_array, GError **error); GArrowTable *
* * *	garrow_table_to_string	(GArrowTable *table, GError **error); gchar *
* * * *	garrow_table_concatenate	(GArrowTable *table, GList *other_tables, GError **error); GArrowTable *
* * x x	garrow_table_slice	(GArrowTable *table, gint64 offset, gint64 length); GArrowTable *
* * *	garrow_table_combine_chunks	(GArrowTable *table, GError **error); GArrowTable *
n *	garrow_feather_write_properties_finalize	(GObject *object); static void 
n * i * *	garrow_feather_write_properties_set_property	(GObject *object, guint prop_id, const GValue *value, GParamSpec *pspec); static void 
n * i * *	garrow_feather_write_properties_get_property	(GObject *object, guint prop_id, GValue *value, GParamSpec *pspec); static void 
n *	garrow_feather_write_properties_init	(GArrowFeatherWriteProperties *object); static void 
n *	garrow_feather_write_properties_class_init	(GArrowFeatherWritePropertiesClass *klass); static void 
* n	garrow_feather_write_properties_new	(void); GArrowFeatherWriteProperties *
c * * * *	garrow_table_write_as_feather	(GArrowTable *table, GArrowOutputStream *sink, GArrowFeatherWriteProperties *properties, GError **error); gboolean 
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
c * *	garrow_record_batch_equal	(GArrowRecordBatch *record_batch, GArrowRecordBatch *other_record_batch); gboolean
c * * c	garrow_record_batch_equal_metadata	(GArrowRecordBatch *record_batch, GArrowRecordBatch *other_record_batch, gboolean check_metadata); gboolean
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
c * *	garrow_record_batch_iterator_equal	(GArrowRecordBatchIterator *iterator, GArrowRecordBatchIterator *other_iterator); gboolean
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
c * *	garrow_chunked_array_equal	(GArrowChunkedArray *chunked_array, GArrowChunkedArray *other_chunked_array); gboolean
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
NB. Type
NB. =========================================================

NB. garrow_string_array_get_stringSHIM =: <@getChar@>@{.@garrow_string_array_get_string
garrow_string_array_get_stringSHIM =: <@<@getCharFree@{.@garrow_string_array_get_string
garrow_boolean_array_get_valueSHIM =: (3&u:)@(7&u:)@>@{.@garrow_boolean_array_get_value

'typeGArrowName typeName typeGetValue typeGetValues typeJ typeJMemr typeDescription' =: (<"1)@|:@(>@(((9{a.)&cut)&.>)@}.@((10{a.)&cut)) 0 : 0
GARROW_TYPE	name	getValue	getValues	Jtype	Jmemr	description
GARROW_TYPE_NA	NA	NA	NA	NA	0	A degenerate NULL type represented as 0 bytes/bits.
GARROW_TYPE_BOOLEAN	bool	garrow_boolean_array_get_valueSHIM	garrow_boolean_array_get_values	bool	1	A boolean value represented as 1-bit.
GARROW_TYPE_UINT8	uint8	garrow_uint8_array_get_value	garrow_uint8_array_get_values	int	4	Little-endian 8-bit unsigned integer.
GARROW_TYPE_INT8	int8	garrow_int8_array_get_value	garrow_int8_array_get_values	int	4	Little-endian 8-bit signed integer.
GARROW_TYPE_UINT16	uint16	garrow_uint16_array_get_value	garrow_uint16_array_get_values	int	4	Little-endian 16-bit unsigned integer.
GARROW_TYPE_INT16	int16	garrow_int16_array_get_value	garrow_int16_array_get_values	int	4	Little-endian 16-bit signed integer.
GARROW_TYPE_UINT32	uint32	garrow_uint32_array_get_value	garrow_uint32_array_get_values	int	4	Little-endian 32-bit unsigned integer.
GARROW_TYPE_INT32	int32	garrow_int32_array_get_value	garrow_int32_array_get_values	int	4	Little-endian 32-bit signed integer.
GARROW_TYPE_UINT64	uint64	garrow_uint64_array_get_value	garrow_uint64_array_get_values	int	4	Little-endian 64-bit unsigned integer.
GARROW_TYPE_INT64	int64	garrow_int64_array_get_value	garrow_int64_array_get_values	int	4	Little-endian 64-bit signed integer.
GARROW_TYPE_HALF_FLOAT	float	NA	NA	float	8	2-byte floating point value.
GARROW_TYPE_FLOAT	float	garrow_float_array_get_value	garrow_float_array_get_values	float	8	4-byte floating point value.
GARROW_TYPE_DOUBLE	double	garrow_double_array_get_value	garrow_double_array_get_values	float	8	8-byte floating point value.
GARROW_TYPE_STRING	utf8	garrow_string_array_get_stringSHIM	NA	char	2	UTF-8 variable-length string.
GARROW_TYPE_BINARY	NA	garrow_binary_array_get_value	NA	byte	2	Variable-length bytes (no guarantee of UTF-8-ness).
GARROW_TYPE_FIXED_SIZE_BINARY	NA	garrow_fixed_size_binary_array_get_value	NA	byte	2	Fixed-size binary. Each value occupies the same number of bytes.
GARROW_TYPE_DATE32	int32	garrow_date32_array_get_value	garrow_date32_array_get_values	int	4	int32 days since the UNIX epoch.
GARROW_TYPE_DATE64	int64	garrow_date64_array_get_value	garrow_date64_array_get_values	int	4	int64 milliseconds since the UNIX epoch.
GARROW_TYPE_TIMESTAMP	NA	garrow_timestamp_array_get_value	garrow_timestamp_array_get_values	int	4	Exact timestamp encoded with int64 since UNIX epoch. Default unit millisecond.
GARROW_TYPE_TIME32	int32	garrow_time32_array_get_value	garrow_time32_array_get_values	int	4	Exact time encoded with int32, supporting seconds or milliseconds
GARROW_TYPE_TIME64	int64	garrow_time64_array_get_value	garrow_time64_array_get_values	int	4	Exact time encoded with int64, supporting micro- or nanoseconds
GARROW_TYPE_INTERVAL_MONTHS	NA	NA	NA	char	4	YEAR_MONTH interval in SQL style.
GARROW_TYPE_INTERVAL_DAY_TIME	NA	NA	NA	char	4	DAY_TIME interval in SQL style.
GARROW_TYPE_DECIMAL128	int128	garrow_decimal128_array_get_value	NA	float	8	Precision- and scale-based decimal type with 128-bit. Storage type depends on the parameters.
GARROW_TYPE_DECIMAL256	int256	garrow_decimal256_array_get_value	NA	float	8	Precision- and scale-based decimal type with 256-bit. Storage type depends on the parameters.
GARROW_TYPE_LIST	NA	NA	NA	NA	0	A list of some logical data type.
GARROW_TYPE_STRUCT	NA	NA	NA	NA	0	Struct of logical types.
GARROW_TYPE_SPARSE_UNION	NA	NA	NA	NA	0	Sparse unions of logical types.
GARROW_TYPE_DENSE_UNION	NA	NA	NA	NA	0	Dense unions of logical types.
GARROW_TYPE_DICTIONARY	NA	NA	NA	NA	0	Dictionary aka Category type.
GARROW_TYPE_MAP	NA	NA	NA	NA	0	A repeated struct logical type.
GARROW_TYPE_EXTENSION	NA	NA	NA	NA	0	Custom data type, implemented by user.
GARROW_TYPE_FIXED_SIZE_LIST	NA	NA	NA	NA	0	Fixed size list of some logical type.
GARROW_TYPE_DURATION	NA	NA	NA	NA	0	Measure of elapsed time in either seconds, milliseconds, microseconds or nanoseconds.
GARROW_TYPE_LARGE_STRING	NA	NA	NA	NA	0	64bit offsets UTF-8 variable-length string.
GARROW_TYPE_LARGE_BINARY	NA	garrow_large_binary_array_get_value	NA	NA	0	64bit offsets Variable-length bytes (no guarantee of UTF-8-ness).
GARROW_TYPE_LARGE_LIST	NA	NA	NA	NA	0	A list of some logical data type with 64-bit offsets.
)

typeIndexLookup =: {{> x {~ y}}
typeNameIndex =:(typeName&i.)@<
typeNameLookup =: {{> x {~ typeNameIndex y}}
NB. typeNameIndex each typeName

NB. Examples:
NB. typeNameIndex 'int64'
NB. typeGetValue&typeNameLookup 'int64'
NB. typeNameIndex 'utf8'
NB. typeDescription typeNameLookup 'utf8'
NB. typeGetValue&typeNameLookup 'utf8'

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
init ''

NB. =========================================================
NB. Array
NB. =========================================================
readArrayType=:{{
  'arrayPt' =. y
  dataTypePt =. ptr garrow_array_get_value_data_type < arrayPt
  getChar (ret ptr garrow_data_type_get_name < dataTypePt)
}}

readArrayTypeIndex=:{{
  'arrayPt' =. y
  datatypePt =. ptr garrow_array_get_value_data_type < arrayPt
  ret garrow_data_type_get_id < datatypePt
}}

readArrayBitWidth=:{{
  'arrayPt' =. y
  datatypePt =. ptr garrow_array_get_value_data_type < arrayPt
  ret garrow_fixed_width_data_type_get_bit_width < datatypePt
}}

readArrayLength=:{{ret garrow_array_get_length < y}}

writeArrayWidth=:{{<lengthPt [ length memw (] lengthPt =. mema width),0,1,4 [ 'length width' =. y}}

readArray=:{{
  'arrayPt' =. y
  indexType =. readArrayTypeIndex arrayPt
  arrayType =. readArrayType arrayPt
  length =. readArrayLength arrayPt
  lengthPt =. writeArrayWidth length;width
  getValueFunc =. typeGetValue&typeIndexLookup indexType NB. lookup functions
  fRun =. getValueFunc,', arrayPt;<'
  results =. ; ret@". each (fRun&,)@": each <"0 i.length
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
readChunk=:{{
  'chunkedArrayPt index' =. y
  ptr@garrow_chunked_array_get_chunk chunkedArrayPt;index
}}

readChunks=:{{
  'chunkedArrayPt' =. y
  nChunks =. ret@garrow_chunked_array_get_n_chunks < chunkedArrayPt
  arrayPts =. readChunk each <"1 (<chunkedArrayPt),.(<"0 i. nChunks)
  readArray each arrayPts
}}

readChunkedArray=:{{
  'chunkedArrayPt' =. y
  NB. length =. > ptr@garrow_chunked_array_get_length < chunkedArrayPt
  NB. valuetype =. > ptr@garrow_chunked_array_get_value_type < chunkedArrayPt
  NB. nrows  =. > ptr@garrow_chunked_array_get_n_rows < chunkedArrayPt
  NB. nnulls =. > ptr@garrow_chunked_array_get_n_nulls < chunkedArrayPt
  NB. valuedatatype =. ptr@garrow_chunked_array_get_value_data_type < chunkedArrayPt
  NB. length;nrows;nnulls;valuetype;<valuedatatype
  readChunks chunkedArrayPt
}}

NB. =========================================================
NB. Field
NB. =========================================================
getFieldName=:{{
  fieldPt =. y
  getChar ptr garrow_field_get_name fieldPt
}}

getFieldDataType=:{{
  'fieldPt' =. y
  dataTypePt =. ptr garrow_field_get_data_type fieldPt
  getChar ret garrow_data_type_get_name < dataTypePt
}}

NB. getFieldNullable=:{{
NB. fieldPt=.y
NB. garrow_field_is_nullable fieldPt
NB. gboolean
NB. }}
NB. getFieldToString=:{{
NB. 'fieldPt'=.y
NB. garrow_field_to_string fieldPt
NB. gchar *
NB. gFree
NB. }}
NB. getFieldToStringMeta {{
NB. 'fieldPt'=.y
NB. garrow_field_to_string_metadata fieldPt;1
NB. gchar *
NB. gFree
NB. }}
NB. {{
NB. 'fieldPt'=.y
NB. garrow_field_has_metadata fieldPt
NB. gboolean
NB. }}

NB. =========================================================
NB. Schema
NB. =========================================================
getSchemaPt =: {{
  tablePt =. y
  ptr garrow_table_get_schema < tablePt
}}

getSchemaFieldPt =: {{
  'schemaPt index'=.y
  ptr garrow_schema_get_field schemaPt;index
}}

getSchemaName=:{{
  'schemaPt index'=.y
  fieldPts =. getSchemaFieldPt (<schemaPt),< index
  name =. getFieldName < fieldPts
  name
}}

getSchemaNames=:{{
  schemaPt =. y
  nFields =. ret garrow_schema_n_fields < schemaPt
  names =. getSchemaName each <"1 (<schemaPt),.<"0 i. nFields
  names
}}

getSchemaFields=:{{
  schemaPt =. y
  nFields =. ret garrow_schema_n_fields < schemaPt
  fieldPts =. getSchemaFieldPt each <"1 (<schemaPt),.<"0 i. nFields
  types =. getFieldDataType@< each fieldPts
  names =. getFieldName@< each fieldPts
  names,:types
}}

readSchemaString=:{{
  tablePt =. y
  schemaPt =. getSchemaPt tablePt
  getChar ret ptr garrow_schema_to_string < schemaPt
}}

readSchema=:{{
  tablePt =. y
  schemaPt =. getSchemaPt tablePt
  getSchemaFields schemaPt
}}

readSchemaColumnName=:{{
  'tablePt index'=.y
  getSchemaName (getSchemaPt tablePt);<index
}}

readSchemaNames=:{{
  tablePt =. y
  schemaPt =. getSchemaPt tablePt
  getSchemaNames schemaPt
}}

NB. =========================================================
NB. Table
NB. =========================================================
tableNRows=:{{ret garrow_table_get_n_rows (< y)}}
tableNCols=:{{ret garrow_table_get_n_columns (< y)}}

readData=:{{
  'tablePt' =. y
  ncols =. tableNCols tablePt
  chunkedArrayPts =. <"0 ptr"1 garrow_table_get_column_data (< tablePt),. <"0 i. ncols
  ,. > readChunkedArray each chunkedArrayPts
}}

readDataColumn=:{{
  'tablePt colIndex' =. y
  ncols =. tableNCols tablePt
  'Index is greater than number of columns. Note columns are zero-indexed.' assert colIndex < ncols
  chunkedArrayPts =. <"0 ptr"1 garrow_table_get_column_data (< tablePt), < colIndex
  ,. ; each readChunkedArray each chunkedArrayPts
}}

readColumn=:{{
  'tablePt colIndex' =. y
  ((<@readSchemaColumnName),.readDataColumn) (< tablePt),< colIndex
}}

readTable=:{{
  'tablePt' =. y
  (readSchemaNames,.readData) tablePt
}}

readsTable=:{{
  'tablePt' =. y
  ((,@readSchemaNames),:(,@:(,.&.>)@:readData)) tablePt
}}

NB. =========================================================
NB. Parquet
NB. =========================================================
readParquet=:{{
  'filepath'=.y
  e=. << mema 4
  r=. gparquet_arrow_file_reader_new_path filepath;e
  t=. gparquet_arrow_file_reader_read_table (ptr r);e
  memf >> e
  ptr t
}}

readParquetSchema=:{{
  'filepath'=.y
  readSchema@readParquet filepath
}}

readParquetData=:{{
  'filepath'=.y
  readData@readParquet filepath
}}

readParquetTable=:{{
  'filepath'=.y
  readTable@readParquet filepath
}}

readsParquetTable=:{{
  'filepath'=.y
  readsTable@readParquet filepath
}}

readParquetColumn =: {{
  'filepath index' =. y
  readColumn (readParquet filepath);<index
}}

writeParquet=: {{
  'filepath'=.y
}}

writeParquetFromTable=: {{
  'table writeOptions' =. y
}}
