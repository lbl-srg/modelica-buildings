within Buildings.Experimental.Templates.AHUs.Validation;
model CoolingCoilDiscretized_json
  extends BaseNoEquipment(redeclare
      UserProject.AHUs.CoolingCoilDiscretized_json ahu);

  Fluid.Sources.Boundary_pT bou2(
    redeclare final package Medium = MediumCoo,
      nPorts=2)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

  inner parameter ExternData.JSONFile dataSource(
    fileName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Experimental/Templates/AHUs/Validation/systems.json"))
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
equation
  connect(bou2.ports[1], ahu.port_coiCooSup)
    annotation (Line(points={{-40,-48},{-2,-48},{-2,-20}}, color={0,127,255}));
  connect(bou2.ports[2], ahu.port_coiCooRet)
    annotation (Line(points={{-40,-52},{2,-52},{2,-20}}, color={0,127,255}));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1), Documentation(info="<html>
<p>
Example with a parameter binding using 
<code>ExternData.JSONFile.getReal()</code>.
Note that in order to access the system <code>id</code> parameter
declared in the AHU template, the previous function call 
(and binding) must be done either when extending the template class (see
Templates.AHUs.Validation.UserProject.AHUs.CoolingCoilDiscretized_json)
or directly in the template class.
</p>
</html>"));
end CoolingCoilDiscretized_json;
