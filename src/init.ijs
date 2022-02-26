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