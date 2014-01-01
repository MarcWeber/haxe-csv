using StringTools;
using mw.NullExtensions;

class CSVReader {
  public var del:Int;
  public var quote:Int;
  public var escape:Int;
  public var linedel:Int; // null means \r or \n

  // the csv thing to be parsed, when parsing a stream csv gets reassigned
  // class vars are used so that no state has to passed around
  public var csv:String;
  public var pos:Int;
  public var l:Int;

  public var r = "\r".fastCodeAt(0);
  public var n = "\n".fastCodeAt(0);

  public function formatDefaults(f:CSVFormat) {
    f.del = f.del.ifNull(";");
    f.quote = f.quote.ifNull("\"");
    f.escape = f.escape.ifNull("\\");
    return f;
  }
  

  public function new(f:CSVFormat){
    del = f.del == null ? null : f.del.fastCodeAt(0);
    quote = f.quote == null ? null : f.quote.fastCodeAt(0);
    escape = f.escape == null ? null : f.escape.fastCodeAt(0);
    linedel = f.linedel == null ? null : f.linedel.fastCodeAt(0);
  }

  public function parseField():Null<String>{
    if (pos >= l){
      return null;
    } else {
      var c = csv.fastCodeAt(pos);
      if (c == quote){
        pos += 1;
        // parse quoted
        var start = pos;

        var r = "";
        while (pos <= l){
          var c = csv.fastCodeAt(pos);

          if (c == quote){
            pos += 1;
            return r+csv.substring(start, pos-1 );
          } else if (c == escape){
            r += csv.substring(start, pos);
            pos += 1;
            start = pos;
          } else {
            pos += 1;
          }
        }
        return null;

      } else {
        var start = pos; pos += 1;
        // parse unquoted
        while (pos <= l){
          var c = csv.fastCodeAt(pos);

          if (c == del){
            // end of cell
            return csv.substring(start, pos);
          }

          if (linedel == null && c == r || c == n){
            // end of line
            if (start == pos) return null;
            else return csv.substring(start, pos);
          }

          pos += 1;
        }
        if (pos == start)
          return null;
        else return csv.substring(start, pos);
      }
    }
  }

  public function parseFields():Array<String>{
    var cells = [];

    while (true){
      var c = parseField();
      if (c == null) break;
      pos += 1; // parseFields did not eat delemiter
      cells.push(c);
    }
    return cells;
  }

  // user interface:
  public function parseLine(s:String):Array<String>{
    pos = 0;
    csv = s;
    l = s.length;

    return parseFields();
  }

  public function parseString(s:String){
    throw "TODO";
  }

}
