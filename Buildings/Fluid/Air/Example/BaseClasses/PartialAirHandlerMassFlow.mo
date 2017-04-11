within Buildings.Fluid.Air.Example.BaseClasses;
partial model PartialAirHandlerMassFlow
  "Partial model for testing air handler at variable mass flowrate"

  package Medium1 = Buildings.Media.Water "Medium model for water";
  package Medium2 = Buildings.Media.Air
    "Medium model for air";
  parameter Buildings.Fluid.Air.Example.Data.Data_I dat
  "Performance data for the air handler";
    Sources.Boundary_pT sin_2(
    redeclare package Medium = Medium2,
    T=dat.nomVal.T_a2_nominal)
    "Sink for air"
    annotation (Placement(transformation(extent={{0,14},{20,34}})));
  Sources.Boundary_pT sou_2(
    redeclare package Medium = Medium2,
    T=dat.nomVal.T_a2_nominal,
    X={0.02,1 - 0.02},
    use_T_in=true,
    use_X_in=true) "Source for air"
    annotation (Placement(transformation(
          extent={{138,14},{118,34}})));
  Sources.MassFlowSource_T sin_1(
    redeclare package Medium = Medium1,
    T=dat.nomVal.T_a1_nominal,
    use_m_flow_in=true) "Sink for water"
    annotation (Placement(transformation(extent={{150,50},{130,70}})));
  Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium1,
    use_T_in=false,
    T=dat.nomVal.T_a1_nominal) "Source for water"
    annotation (Placement(transformation(extent={{-2,52},{18,72}})));
  Modelica.Blocks.Sources.Constant relHum(k=0.8) "Relative humidity"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Buildings.Utilities.Psychrometrics.X_pTphi x_pTphi(use_p_in=false)
    annotation (Placement(transformation(extent={{150,-42},{170,-22}})));
  Modelica.Blocks.Sources.Constant temSou_2(k=dat.nomVal.T_a2_nominal)
    "Temperature boundary condition"
    annotation (Placement(transformation(extent={{100,-38},{120,-18}})));
  Modelica.Blocks.Math.Gain mWat_flow(k=-dat.nomVal.m1_flow_nominal)
    "Water mass flow rate"
    annotation (Placement(transformation(extent={{-42,100},{-22,120}})));
  Modelica.Blocks.Sources.TimeTable mWatGai(
    table=[0,1; 3600*0.1,1; 3600*0.2,0.01; 3600*0.3,0.01])
    "Gain for water mass flow rate"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
equation
  connect(x_pTphi.X, sou_2.X_in) annotation (Line(
      points={{171,-32},{178,-32},{178,-34},{186,-34},{186,20},{140,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(relHum.y, x_pTphi.phi) annotation (Line(
      points={{121,-60},{136,-60},{136,-38},{148,-38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSou_2.y, x_pTphi.T) annotation (Line(
      points={{121,-28},{134,-28},{134,-32},{148,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSou_2.y, sou_2.T_in) annotation (Line(
      points={{121,-28},{134,-28},{134,0},{160,0},{160,28},{140,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mWatGai.y, mWat_flow.u) annotation (Line(
      points={{-59,110},{-44,110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mWat_flow.y, sin_1.m_flow_in) annotation (Line(
      points={{-21,110},{160,110},{160,68},{150,68}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},
            {180,180}})),
            Diagram(coordinateSystem(preserveAspectRatio=false,
             extent={{-120,-100},{180,180}})));
end PartialAirHandlerMassFlow;
