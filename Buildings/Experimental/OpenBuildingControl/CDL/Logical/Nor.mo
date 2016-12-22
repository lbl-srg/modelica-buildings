within Buildings.Experimental.OpenBuildingControl.CDL.Logical;
block Nor "Logical 'nor': y = not (u1 or u2)"
  extends Modelica.Blocks.Interfaces.partialBooleanSI2SO;
equation
  y = not (u1 or u2);
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={Text(
          extent={{-90,40},{90,-40}},
          lineColor={0,0,0},
          textString="nor")}), Documentation(info="<html>
<p>
The output is <code>true</code> if none of the inputs is <code>true</code>, otherwise
the output is <code>false</code>.
</p>
</html>"));
end Nor;
