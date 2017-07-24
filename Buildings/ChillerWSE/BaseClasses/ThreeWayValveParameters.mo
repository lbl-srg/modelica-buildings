within Buildings.ChillerWSE.BaseClasses;
partial model ThreeWayValveParameters
  "Model with parameters for a three-way valve"

  parameter Boolean use_Controller=false
    "Activate the use of three-way valve: True-use three-way valve; False-not use the three-way valve";

  parameter Real fraK_ThrWayVal(min=0, max=1) = 0.7 if use_Controller
    "Fraction Kv(port_3&rarr;port_2)/Kv(port_1&rarr;port_2)for the three-way valve"
    annotation(Dialog(group="Three-way Valve", enable=use_Controller));
  parameter Real l_ThrWayVal[2](min=1e-10, max=1) = {0.0001,0.0001} if use_Controller
    "Bypass valve leakage, l=Kv(y=0)/Kv(y=1)"
    annotation(Dialog(group="Three-way Valve",enable=use_Controller));
  parameter Real R=50 if use_Controller
    "Rangeability, R=50...100 typically for the three-way valve"
    annotation(Dialog(group="Three-way Valve",enable=use_Controller));
  parameter Real delta0=0.01 if use_Controller
    "Range of significant deviation from equal percentage law for the three-way valve"
    annotation(Dialog(group="Three-way Valve",enable=use_Controller));

  //Advanced
  parameter Modelica.Fluid.Types.PortFlowDirection portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Bidirectional if
       use_Controller
    "Flow direction for port_1 in the three-way valve"
   annotation(Dialog(tab="Advanced",enable=use_Controller));
  parameter Modelica.Fluid.Types.PortFlowDirection portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Bidirectional if
       use_Controller
    "Flow direction for port_2 in the three-way valve"
   annotation(Dialog(tab="Advanced",enable=use_Controller));
  parameter Modelica.Fluid.Types.PortFlowDirection portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Bidirectional if
       use_Controller
    "Flow direction for port_3 in the three-way valve"
   annotation(Dialog(tab="Advanced",enable=use_Controller));


end ThreeWayValveParameters;
