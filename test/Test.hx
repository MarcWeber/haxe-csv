class Test {
  static function main() {
    var testCases:Array<{csv:String, name:String, expected:Array<String>, format: CSVFormat}> = [
      {
        name: 'simple',
        csv: "abc,foo,bar",
        format: {
          del: ","
        },
        expected: ["abc","foo","bar"]
      },
      {
        name: 'quoting  / escaping',
        csv: "abc;\"foo\";\"ba\\r\"",
        format: {
          quote: "\"",
          del: ";",
          escape: "\\"
        },
        expected: ["abc","foo","bar"]
      }
    ];

    for (t in testCases){
      var c = new CSVReader(t.format);
      var result = c.parseLine(t.csv);
      if (haxe.Serializer.run(result) != haxe.Serializer.run(t.expected))
        throw 'bad test case ${t.name} got: ${result}';
    }
  }
}
