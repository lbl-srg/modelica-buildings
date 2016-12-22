within Buildings.Experimental.OpenBuildingControl.CDL.Logical;
block Not "Logical 'not': y = not u"
  extends Modelica.Blocks.Interfaces.partialBooleanSISO;

equation
  y = not u;
  annotation (
    defaultComponentName="not1",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-90,40},{90,-40}},
          lineColor={0,0,0},
          textString="not")}),
    Documentation(info="<html>
<p>
The output is <b>true</b> if the input is <b>false</b>, otherwise
the output is <b>false</b>.
</p>
</html>"));
end Not;
