within Buildings.Fluid.Movers.BaseClasses.Euler;
record lookupTables
  "Record for efficiency and power curves computed with Euler number"
  extends Modelica.Icons.Record;
  parameter Real eta[11,11](each min=0, each max=1)=
    [0, ascSeq; transpose(ascSeq), zeros(10,10)]
    "Look-up table for mover efficiency";
  parameter Real P[11,11](each min=0)=
    [0, ascSeq; transpose(ascSeq), zeros(10,10)]
    "Look-up table for mover power";
  final parameter Real ascSeq[1,:]=[1,2,3,4,5,6,7,8,9,10]
    "2D ascending sequence used for initial table construction";
  // CombiTable2D requires that the first element is zero
  //   and the first row and first column are ascending.
  //   This declaration cannot be achieved by linspace()
  //   which returns a 1-D array that cannot be transposed.

  annotation (
Documentation(info="<html>
<p>
Record for both efficiency and power curves computed from the Euler number. 
[Documentation pending.]
[The content below is no longer valid.]
This record differs from 
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters</a>
and 
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.powerParameters\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.powerParameters</a>
in the following ways:
<ul>
<li>
The efficiency curve and the power curve are stored in the same record.
</li>
<li>
The support points for flow rate in this record normally does not match 
the input data, but is instead decided by 
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Euler.computeTables\">
Buildings.Fluid.Movers.BaseClasses.Euler.computeTables</a>.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
October 29, 2021, by Hongxiang Fu:<br/>
First implementation. This is for 
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
</ul>
</html>"));
end lookupTables;
