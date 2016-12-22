within Buildings.Experimental.OpenBuildingControl.CDL.Logical;
block Change
  "Output y is true, if the input u has a rising or falling edge (y = change(u))"

  parameter Boolean pre_u_start=false "Start value of pre(u) at initial time";
  extends Modelica.Blocks.Interfaces.partialBooleanSISO;

initial equation
  pre(u) = pre_u_start;
equation
  y = change(u);
  annotation (
    defaultComponentName="change1",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-90,40},{90,-40}},
          lineColor={0,0,0},
          textString="change")}),
    Documentation(info="<html>
<p>
The output is <code>true</code> if the Boolean input has either a rising edge
from <code>false</code> to <code>true</code> or a falling edge from
<code>true</code> to <code>false</code>, otherwise
the output is <code>false</code>.
</p>
</html>"));
end Change;
