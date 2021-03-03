within Buildings.Experimental.Templates.AHUs.Fans.Data;
record MultipleVariable "Record for nFan identical fans"
  extends SingleVariable;

  parameter Integer nFan = 1
    "Number of fans"
    annotation(Evaluate=true,
      Dialog(group="Configuration"));

end MultipleVariable;
