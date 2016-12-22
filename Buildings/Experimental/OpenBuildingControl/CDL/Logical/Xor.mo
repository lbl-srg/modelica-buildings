within Buildings.Experimental.OpenBuildingControl.CDL.Logical;
block Xor "Logical 'xor': y = u1 xor u2"
  extends Modelica.Blocks.Interfaces.partialBooleanSI2SO;
equation
  y = not ((u1 and u2) or (not u1 and not u2));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={Text(
          extent={{-90,40},{90,-40}},
          lineColor={0,0,0},
          textString="xor")}), Documentation(info="<html>
<p>
The output is <b>true</b> if exactly one input is <b>true</b>, otherwise
the output is <b>false</b>.
</p>
</html>"));
end Xor;
