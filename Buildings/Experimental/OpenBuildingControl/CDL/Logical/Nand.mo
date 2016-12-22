within Buildings.Experimental.OpenBuildingControl.CDL.Logical;
block Nand "Logical 'nand': y = not (u1 and u2)"
  extends Modelica.Blocks.Interfaces.partialBooleanSI2SO;
equation
  y = not (u1 and u2);
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={Text(
          extent={{-90,40},{90,-40}},
          lineColor={0,0,0},
          textString="nand")}), Documentation(info="<html>
<p>
The output is <b>true</b> if at least one input is <b>false</b>, otherwise
the output is <b>false</b>.
</p>
</html>"));
end Nand;
