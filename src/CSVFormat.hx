typedef CSVFormat = {
  // always only the first char will be taken into account (using fastCodeAt)
  ?del:String,
  ?quote:String,
  ?escape:String,
  // null means take \r or \n as line delemiter (in any order arbitrary often, thus this should fit \r\n)
  // this might change ..
  ?linedel:String
}
