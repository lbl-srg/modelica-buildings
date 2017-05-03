within Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Validation;
model ConstantStatus "Validation model for the ConstantStatus block"
extends Modelica.Icons.Example;

   Buildings.Experimental.OpenBuildingControl.CDL.Continuous.ConstantStatus conSta(refSta=CDL.Types.Status.FreezeProtectionStage0)
     "Block that outputs the cosine of the input"
     annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  annotation (
  experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Continuous/Validation/ConstantStatus.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Continuous.ConstantStatus\">
Buildings.Experimental.OpenBuildingControl.CDL.Continuous.ConstantStatus</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 02, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end ConstantStatus;
