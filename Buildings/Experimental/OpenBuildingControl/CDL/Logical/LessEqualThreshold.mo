within Buildings.Experimental.OpenBuildingControl.CDL.Logical;
block LessEqualThreshold
  "Output y is true, if input u is less or equal than threshold"
  extends Modelica.Blocks.Interfaces.partialBooleanThresholdComparison;
equation
  y = u <= threshold;
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={Text(
          extent={{-90,-40},{60,40}},
          lineColor={0,0,0},
          textString="<=")}), Documentation(info="<html>
<p>
The output is <code>true</code> if the Real input is less than or equal to
parameter <code>threshold</code>, otherwise
the output is <code>false</code>.
</p>
</html>"));
end LessEqualThreshold;
