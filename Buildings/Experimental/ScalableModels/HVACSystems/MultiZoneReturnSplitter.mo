within Buildings.Experimental.ScalableModels.HVACSystems;
model MultiZoneReturnSplitter
  "Splitter group for returning air from different zones"
  package MediumA = Buildings.Media.Air "Medium model";

  parameter Integer nZon(min=1) = 1 "Number of zones per floor"
    annotation(Evaluate=true);
  parameter Integer nFlo(min=1) = 1 "Number of floors"
    annotation(Evaluate=true);

  final parameter Modelica.SIunits.Volume Vol=AFlo*hRoo "Volume";
  parameter Modelica.SIunits.Area AFlo = 6*8 "Floor area";
  parameter Modelica.SIunits.Length hRoo = 2.7 "Average room height";

  constant Real conv=1.2/3600 "Conversion factor for nominal mass flow rate";
  parameter Modelica.SIunits.MassFlowRate m0_flow=7*Vol*conv
    "Design mass flow rate for each zone";

  parameter Modelica.SIunits.MassFlowRate m0_flow_1[nZon, nFlo]={{
    m0_flow*(nZon-i+1)*(nFlo-j+1) for j in 1:nFlo} for i in 1:nZon}
    "Nominal flow rate for spliiter branch 1";
  parameter Modelica.SIunits.MassFlowRate m0_flow_2[nZon, nFlo]={{
    m0_flow*(nZon-i)*(nFlo-j) for j in 1:nFlo} for i in 1:nZon}
    "Nominal flow rate for spliiter branch 2";
  parameter Modelica.SIunits.MassFlowRate m0_flow_3[nZon, nFlo]={{
    m0_flow for j in 1:nFlo} for i in 1:nZon}
    "Nominal flow rate for spliiter branch 3";

  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b splRetOut(
      redeclare each package Medium = MediumA) "Splitter group outlet"
    annotation (Placement(transformation(extent={{-84,-19},{-46,-9}}),
        iconTransformation(extent={{-94,-26},{-56,-16}})));
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b splRetFrZon[nZon,nFlo](
      redeclare each package Medium = MediumA) "Splitter group from zones"
    annotation (Placement(transformation(extent={{-18,54},{18,64}}),
        iconTransformation(extent={{-1,64},{35,74}})));

  Buildings.Fluid.FixedResistances.Junction splRet[nZon, nFlo](
    redeclare each package Medium = MediumA,
    m_flow_nominal={{{m_flow_1[i,j],m_flow_2[i,j],m_flow_3[i,j]} for j in 1:nFlo} for i in 1:nZon},
    dp_nominal(displayUnit="Pa") = {10,10,10},
    each from_dp=true,
    each linearized=true,
    each energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Splitter for room supply"
    annotation (Placement(transformation(extent={{-10,-10},{10,-30}})));

equation
  for iZone in 1:nZon-1 loop
    for iFlo in 1:nFlo-1 loop
      connect(splRet[iZon, iFlo].port_2, splRet[iZon+1, iFlo].port_1) annotation (Line(
        points={{10,-20},{-22,-20},{-22,-38},{18,-38},{18,-20},{-10,-20}},color={191, 0,0}));
    end for;
  end for;

  connect(splRetOut, splSup[1, 1].port_1) annotation (Line(
        points={{-65,-14},{-65,-14},{-10,-14},{-10,-20}},                 color={191, 0,0}));
  for iZone in 1:nZon-1 loop
    for iFlo in 1:nFlo-1 loop
      connect(splRetFrZon[iZon, iFlo], splRet[iZon, iFlo].port_3) annotation (Line(
        points={{0,59},{0,59},{0,2},{0,-10}},                             color={191, 0,0}));
    end for;
  end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},
            {120,100}}), graphics={
        Polygon(
          points={{-42,-62},{-42,6},{4,-2},{4,28},{32,28},{32,-6},{100,-18},{100,
              -48},{-42,-62}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,-50},{-42,-10},{-42,-50}},
          lineColor={28,108,200},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,-52},{-42,-6},{10,-16},{10,28},{26,28},{26,-18},{100,-30},
              {100,-40},{-42,-52}},
          lineColor={0,0,0},
          fillColor={85,85,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{0,-14},{32,-46}},
          lineColor={28,108,200},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Line(points={{18,28},{18,64}}, color={0,0,0}),
        Line(points={{-56,-22},{-42,-22}}, color={0,0,0}),
        Text(
          extent={{-86,-2},{-60,-14}},
          lineColor={0,0,0},
          fillColor={85,85,255},
          fillPattern=FillPattern.Solid,
          textString="splRetOut"),
        Text(
          extent={{22,64},{50,48}},
          lineColor={0,0,0},
          fillColor={85,85,255},
          fillPattern=FillPattern.Solid,
          textString="splRetFrZon")}),                           Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{120,100}})));
end MultiZoneReturnSplitter;
