within Buildings.Experimental.OpenBuildingControl.CDL.Logical;
block Or "Logical 'or': y = u1 or u2"
  extends Modelica.Blocks.Interfaces.partialBooleanSI2SO;
equation
  y = u1 or u2;
  annotation (
    defaultComponentName="or1",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-90,40},{90,-40}},
          lineColor={0,0,0},
          textString="or")}),
    Documentation(info="<html>
<p>
The output is <b>true</b> if at least one input is <b>true</b>, otherwise
the output is <b>false</b>.
</p>
</html>"));
end Or;
