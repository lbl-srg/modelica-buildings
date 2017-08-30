within Buildings.Applications.DataCenters.Examples.BaseClasses.Examples;
model OADamperController
  "Example that demonstrate the use of model 
  Buildings.Applications.DataCenters.Examples.BaseClasses.OADamperController"
  extends Modelica.Icons.Example;
  replaceable package Medium =
      Buildings.Media.Air;
  parameter Modelica.SIunits.MassFlowRate mA_flow_nominal=0.43
    "Nominal air flowrate";
  Buildings.Applications.DataCenters.Examples.BaseClasses.OADamperController
    oaDamCon(minOAFra=0, Ti=1)
    "OA damper controller"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Modelica.Blocks.Sources.Constant MATSet(
    k = 291.15)
    "Mixed air temperature setpoint"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Blocks.Sources.CombiTimeTable cooMod(
    table=[0,0;
           120,0;
           120,1;
           240,1;
           240,2;
           360,2])
    "Cooling mode signal: 0 - free cooling; 1 - partial mechanical cooling; 2 - fully mechanical cooling"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Fluid.Sources.Boundary_pT OA(
    redeclare package Medium = Medium,
    nPorts=2,
    use_T_in=true,
    p(displayUnit="Pa") = 100000)
    "Boundary conditions for outside air"
    annotation (Placement(transformation(extent={{-70,-32},{-50,-12}})));
  Buildings.Fluid.Actuators.Dampers.MixingBox eco(
    redeclare package Medium = Medium,
    mOut_flow_nominal=mA_flow_nominal,
    dpOut_nominal=20,
    mRec_flow_nominal=mA_flow_nominal,
    dpRec_nominal=20,
    mExh_flow_nominal=mA_flow_nominal,
    dpExh_nominal=20,
    use_inputFilter=false)
    "Airside economizer"
    annotation (Placement(transformation(extent={{-40,-36},{-20,-16}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemMixAir(
    redeclare package Medium = Medium,
    m_flow_nominal=mA_flow_nominal)
    "Temperature sensor for mixed air"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Buildings.Fluid.Sources.Boundary_pT roo(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=true,
    p=100000 + 30) "Boundary conditions for room air"
    annotation (Placement(transformation(extent={{52,-60},{32,-40}})));
  Modelica.Blocks.Sources.CombiTimeTable OAT(
    table=[0,273.15 + 5;
           120,273.15 + 5;
           120,273.15 + 20;
           240,273.15 + 20;
           240,273.15 + 30;
           360,273.15 + 30])
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Modelica.Blocks.Sources.Constant RAT(k = 298.15) "Return air temperature"
    annotation (Placement(transformation(extent={{90,-56},{70,-36}})));
  Buildings.Fluid.Sources.Boundary_pT SA(
    redeclare package Medium = Medium,
    nPorts=1,
    p(displayUnit="Pa") = 100000 - 30) "Boundary conditions for supply air"
    annotation (Placement(transformation(extent={{52,-30},{32,-10}})));
equation
  connect(MATSet.y, oaDamCon.MATSet)
    annotation (Line(points={{-59,90},{-40,90},
          {-40,68},{-12,68}},color={0,0,127}));
  connect(cooMod.y[1], oaDamCon.cooMod)
    annotation (Line(points={{-59,30},{-40,30},
          {-40,60},{-12,60}},    color={0,0,127}));
  connect(OA.ports[1], eco.port_Out)
    annotation (Line(points={{-50,-20},{-50,-20},
          {-40,-20}}, color={0,127,255}));
  connect(eco.port_Exh, OA.ports[2])
    annotation (Line(points={{-40,-32},{-44,-32},
          {-44,-24},{-50,-24}}, color={0,127,255}));
  connect(eco.port_Sup,senTemMixAir. port_a)
    annotation (Line(points={{-20,-20},{-20,-20},{-10,-20}},
                color={0,127,255}));
  connect(senTemMixAir.T, oaDamCon.MAT)
    annotation (Line(points={{0,-9},{0,-9},{
          0,20},{-32,20},{-32,64},{-12,64}}, color={0,0,127}));
  connect(oaDamCon.y, eco.y)
    annotation (Line(points={{11,60},{20,60},{20,0},{-30,
          0},{-30,-14}}, color={0,0,127}));
  connect(eco.port_Ret, roo.ports[1])
    annotation (Line(points={{-20,-32},{-20,-32},
          {-16,-32},{-16,-50},{16,-50},{32,-50}},color={0,127,255}));
  connect(OAT.y[1], OA.T_in)
    annotation (Line(points={{-79,-20},{-76,-20},{-76,-18},
          {-72,-18}}, color={0,0,127}));
  connect(RAT.y, roo.T_in)
    annotation (Line(points={{69,-46},{60,-46},{54,-46}},
                    color={0,0,127}));
  connect(senTemMixAir.port_b, SA.ports[1])
    annotation (Line(points={{10,-20},{32,-20}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Applications/DataCenters/Examples/BaseClasses/Examples/OADamperController.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<P>
This example demonstrates how the OA damper position changes under different cooling mode. During the first 120s, the system is in 
free cooling mode, and the damper position is controlled to maintain the mixed air temperature (MAT) at its setpoint. In the second
120s, the system is in partial mechanical cooling mode and the OA damper is fully open. As a result, the MAT is equal to the 
outdoor air temperature (OAT). In the last 120s, the system is in fully mechnical cooling mode, which means the OA damper is fully closed, and
the MAT equals to the return air temperature (RAT).
</P>
</html>", revisions="<html>
<ul>
<li>
August 29, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end OADamperController;
