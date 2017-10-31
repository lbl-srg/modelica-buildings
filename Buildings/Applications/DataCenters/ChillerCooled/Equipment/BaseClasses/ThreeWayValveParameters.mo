within Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses;
partial model ThreeWayValveParameters
  "Model with parameters for a three-way valve"
  parameter Boolean activate_ThrWayVal
    "Activate the use of three-way valve: True-use three-way valve; False-not use the three-way valve";
  parameter Real fraK_ThrWayVal(
    min=0,
    max=1) = 0.7
    "Fraction Kv(port_3&rarr;port_2)/Kv(port_1&rarr;port_2)for the three-way valve"
    annotation(Dialog(group="Three-way Valve", enable=activate_ThrWayVal));
  parameter Real l_ThrWayVal[2](
    each min=1e-10,
    each max=1) = {0.0001,0.0001}
    "Bypass valve leakage, l=Kv(y=0)/Kv(y=1)"
    annotation(Dialog(group="Three-way Valve",enable=activate_ThrWayVal));
  parameter Real R=50
    "Rangeability, R=50...100 typically for the three-way valve"
    annotation(Dialog(group="Three-way Valve",enable=activate_ThrWayVal));
  parameter Real delta0=0.01
    "Range of significant deviation from equal percentage law for the three-way valve"
    annotation(Dialog(group="Three-way Valve",enable=activate_ThrWayVal));
  //Advanced
  parameter Modelica.Fluid.Types.PortFlowDirection portFlowDirection_1=
    Modelica.Fluid.Types.PortFlowDirection.Bidirectional
    "Flow direction for port_1 in the three-way valve"
   annotation(Dialog(tab="Advanced",enable=activate_ThrWayVal));
  parameter Modelica.Fluid.Types.PortFlowDirection portFlowDirection_2=
    Modelica.Fluid.Types.PortFlowDirection.Bidirectional
    "Flow direction for port_2 in the three-way valve"
   annotation(Dialog(tab="Advanced",enable=activate_ThrWayVal));
  parameter Modelica.Fluid.Types.PortFlowDirection portFlowDirection_3=
    Modelica.Fluid.Types.PortFlowDirection.Bidirectional
    "Flow direction for port_3 in the three-way valve"
   annotation(Dialog(tab="Advanced",enable=activate_ThrWayVal));

  annotation (Documentation(revisions="<html>
<ul>
<li>
June 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Partial model that decribes the parameters of a three-way valve.
</p>
</html>"));
end ThreeWayValveParameters;
