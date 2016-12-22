within Buildings.Experimental.OpenBuildingControl.CDL.Logical;
block And "Logical 'and': y = u1 and u2"
  extends Modelica.Blocks.Interfaces.partialBooleanSI2SO;
equation
  y = u1 and u2;
  annotation (
    defaultComponentName="and1",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-90,40},{90,-40}},
          lineColor={0,0,0},
          textString="and")}),
    Documentation(info="<html>
<p>
The output is <code>true</code> if all inputs are <code>true</code>, otherwise
the output is <code>false</code>.
</p>
</html>"));
end And;
