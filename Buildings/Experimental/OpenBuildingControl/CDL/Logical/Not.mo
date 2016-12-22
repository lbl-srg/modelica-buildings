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
The output is <code>true</code> if the input is <code>false</code>, otherwise
the output is <code>false</code>.
</p>
</html>"));
end Not;
