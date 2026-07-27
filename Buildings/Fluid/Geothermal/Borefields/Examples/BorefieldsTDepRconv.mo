within Buildings.Fluid.Geothermal.Borefields.Examples;
model BorefieldsTDepRconv
  "Validation model for temperature-dependent convection resistance in single-U-tube borefields"
  extends Modelica.Icons.Example;

  package MediumWat = Buildings.Media.Water
    "Constant-property water transport medium";

  package MediumGly =
    Buildings.Media.Antifreeze.PropyleneGlycolWater(
      property_T=293.15,
      X_a=0.40)
    "Constant-property propylene glycol/water transport medium";

  parameter Modelica.Units.SI.Time tLoaAgg=300
    "Time resolution of load aggregation";

  parameter Modelica.Units.SI.Temperature TGro=283.15
    "Ground temperature";

  parameter Modelica.Units.SI.Temperature TIn=308.15
    "Common inlet temperature for all cases";

  parameter Modelica.Units.SI.MassFlowRate mBor_flow_nominal_wat=0.30
    "Nominal mass flow rate per borehole for water cases";

  parameter Modelica.Units.SI.MassFlowRate mBor_flow_nominal_gly=0.20
    "Nominal mass flow rate per borehole for glycol cases, selected near regime transition";

  parameter Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Example
    borFieDatFixWat(
      conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
        borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube,
        use_Rb=false,
        use_TDepRConv=false,
        mBor_flow_nominal=mBor_flow_nominal_wat))
    "Borefield data for fixed-property water case"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

  parameter Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Example
    borFieDatWat(
      conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
        borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube,
        use_Rb=false,
        use_TDepRConv=true,
        fluidPropertyEvaluation=
          Buildings.Fluid.Geothermal.Borefields.Types.FluidPropertyEvaluation.Water,
        mBor_flow_nominal=mBor_flow_nominal_wat))
    "Borefield data for temperature-dependent water-correlation case"
    annotation (Placement(transformation(extent={{-70,80},{-50,100}})));

  parameter Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Example
    borFieDatFixGly(
      conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
        borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube,
        use_Rb=false,
        use_TDepRConv=false,
        X_a=0.40,
        mBor_flow_nominal=mBor_flow_nominal_gly))
    "Borefield data for fixed-property glycol case"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));

  parameter Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Example
    borFieDatGly(
      conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
        borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube,
        use_Rb=false,
        use_TDepRConv=true,
        fluidPropertyEvaluation=
          Buildings.Fluid.Geothermal.Borefields.Types.FluidPropertyEvaluation.PropyleneGlycolWater,
        X_a=0.40,
        mBor_flow_nominal=mBor_flow_nominal_gly))
    "Borefield data for temperature-dependent glycol-correlation case"
    annotation (Placement(transformation(extent={{-10,80},{10,100}})));

  Buildings.Fluid.Geothermal.Borefields.OneUTube borFieFixWat(
    redeclare package Medium = MediumWat,
    borFieDat=borFieDatFixWat,
    tLoaAgg=tLoaAgg,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TExt0_start=TGro,
    allowFlowReversal=false)
    "Fixed-property water borefield"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));

  Buildings.Fluid.Geothermal.Borefields.OneUTube borFieWat(
    redeclare package Medium = MediumWat,
    borFieDat=borFieDatWat,
    tLoaAgg=tLoaAgg,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TExt0_start=TGro,
    allowFlowReversal=false)
    "Water borefield with local temperature-dependent water correlations"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));

  Buildings.Fluid.Geothermal.Borefields.OneUTube borFieFixGly(
    redeclare package Medium = MediumGly,
    borFieDat=borFieDatFixGly,
    tLoaAgg=tLoaAgg,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TExt0_start=TGro,
    allowFlowReversal=false)
    "Fixed-property glycol borefield"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));

  Buildings.Fluid.Geothermal.Borefields.OneUTube borFieGly(
    redeclare package Medium = MediumGly,
    borFieDat=borFieDatGly,
    tLoaAgg=tLoaAgg,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TExt0_start=TGro,
    allowFlowReversal=false)
    "Glycol borefield with local temperature-dependent glycol correlations"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));

  Buildings.Fluid.Sources.MassFlowSource_T souFixWat(
    redeclare package Medium = MediumWat,
    nPorts=1,
    use_T_in=false,
    m_flow=borFieDatFixWat.conDat.mBorFie_flow_nominal,
    T=TIn)
    "Inlet source for fixed-property water case"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TInFixWat(
    redeclare package Medium = MediumWat,
    m_flow_nominal=borFieDatFixWat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature sensor for fixed-property water case"
    annotation (Placement(transformation(extent={{-58,50},{-38,70}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TOutFixWat(
    redeclare package Medium = MediumWat,
    m_flow_nominal=borFieDatFixWat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Outlet temperature sensor for fixed-property water case"
    annotation (Placement(transformation(extent={{38,50},{58,70}})));

  Buildings.Fluid.Sources.Boundary_pT sinFixWat(
    redeclare package Medium = MediumWat,
    nPorts=1)
    "Outlet sink for fixed-property water case"
    annotation (Placement(transformation(extent={{90,50},{70,70}})));

  Buildings.Fluid.Sources.MassFlowSource_T souWat(
    redeclare package Medium = MediumWat,
    nPorts=1,
    use_T_in=false,
    m_flow=borFieDatWat.conDat.mBorFie_flow_nominal,
    T=TIn)
    "Inlet source for water-correlation case"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TInWatSen(
    redeclare package Medium = MediumWat,
    m_flow_nominal=borFieDatWat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature sensor for water-correlation case"
    annotation (Placement(transformation(extent={{-58,10},{-38,30}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TOutWat(
    redeclare package Medium = MediumWat,
    m_flow_nominal=borFieDatWat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Outlet temperature sensor for water-correlation case"
    annotation (Placement(transformation(extent={{38,10},{58,30}})));

  Buildings.Fluid.Sources.Boundary_pT sinWat(
    redeclare package Medium = MediumWat,
    nPorts=1)
    "Outlet sink for water-correlation case"
    annotation (Placement(transformation(extent={{90,10},{70,30}})));

  Buildings.Fluid.Sources.MassFlowSource_T souFixGly(
    redeclare package Medium = MediumGly,
    nPorts=1,
    use_T_in=false,
    m_flow=borFieDatFixGly.conDat.mBorFie_flow_nominal,
    T=TIn)
    "Inlet source for fixed-property glycol case"
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TInFixGly(
    redeclare package Medium = MediumGly,
    m_flow_nominal=borFieDatFixGly.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature sensor for fixed-property glycol case"
    annotation (Placement(transformation(extent={{-58,-30},{-38,-10}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TOutFixGly(
    redeclare package Medium = MediumGly,
    m_flow_nominal=borFieDatFixGly.conDat.mBorFie_flow_nominal,
    tau=0)
    "Outlet temperature sensor for fixed-property glycol case"
    annotation (Placement(transformation(extent={{38,-30},{58,-10}})));

  Buildings.Fluid.Sources.Boundary_pT sinFixGly(
    redeclare package Medium = MediumGly,
    nPorts=1)
    "Outlet sink for fixed-property glycol case"
    annotation (Placement(transformation(extent={{90,-30},{70,-10}})));

  Buildings.Fluid.Sources.MassFlowSource_T souGly(
    redeclare package Medium = MediumGly,
    nPorts=1,
    use_T_in=false,
    m_flow=borFieDatGly.conDat.mBorFie_flow_nominal,
    T=TIn)
    "Inlet source for glycol-correlation case"
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TInGly(
    redeclare package Medium = MediumGly,
    m_flow_nominal=borFieDatGly.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature sensor for glycol-correlation case"
    annotation (Placement(transformation(extent={{-58,-70},{-38,-50}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TOutGly(
    redeclare package Medium = MediumGly,
    m_flow_nominal=borFieDatGly.conDat.mBorFie_flow_nominal,
    tau=0)
    "Outlet temperature sensor for glycol-correlation case"
    annotation (Placement(transformation(extent={{38,-70},{58,-50}})));

  Buildings.Fluid.Sources.Boundary_pT sinGly(
    redeclare package Medium = MediumGly,
    nPorts=1)
    "Outlet sink for glycol-correlation case"
    annotation (Placement(transformation(extent={{90,-70},{70,-50}})));

  Modelica.Units.SI.TemperatureDifference dTOutWat =
    TOutWat.T - TOutFixWat.T
    "Outlet temperature difference between water-correlation and fixed-property water case";

  Modelica.Units.SI.TemperatureDifference dTOutGly =
    TOutGly.T - TOutFixGly.T
    "Outlet temperature difference between glycol-correlation and fixed-property glycol case";

  Modelica.Units.SI.TemperatureDifference dTOutFixGlyWat =
    TOutFixGly.T - TOutFixWat.T
    "Outlet temperature difference between fixed-property glycol and fixed-property water";

  Modelica.Units.SI.TemperatureDifference dTOutTDepGlyWat =
    TOutGly.T - TOutWat.T
    "Outlet temperature difference between T-dependent glycol and T-dependent water";

equation
  connect(souFixWat.ports[1], TInFixWat.port_a)
    annotation (Line(points={{-70,60},{-58,60}}, color={0,127,255}));
  connect(TInFixWat.port_b, borFieFixWat.port_a)
    annotation (Line(points={{-38,60},{-10,60}}, color={0,127,255}));
  connect(borFieFixWat.port_b, TOutFixWat.port_a)
    annotation (Line(points={{10,60},{38,60}}, color={0,127,255}));
  connect(TOutFixWat.port_b, sinFixWat.ports[1])
    annotation (Line(points={{58,60},{70,60}}, color={0,127,255}));

  connect(souWat.ports[1], TInWatSen.port_a)
    annotation (Line(points={{-70,20},{-58,20}}, color={0,127,255}));
  connect(TInWatSen.port_b, borFieWat.port_a)
    annotation (Line(points={{-38,20},{-10,20}}, color={0,127,255}));
  connect(borFieWat.port_b, TOutWat.port_a)
    annotation (Line(points={{10,20},{38,20}}, color={0,127,255}));
  connect(TOutWat.port_b, sinWat.ports[1])
    annotation (Line(points={{58,20},{70,20}}, color={0,127,255}));

  connect(souFixGly.ports[1], TInFixGly.port_a)
    annotation (Line(points={{-70,-20},{-58,-20}}, color={0,127,255}));
  connect(TInFixGly.port_b, borFieFixGly.port_a)
    annotation (Line(points={{-38,-20},{-10,-20}}, color={0,127,255}));
  connect(borFieFixGly.port_b, TOutFixGly.port_a)
    annotation (Line(points={{10,-20},{38,-20}}, color={0,127,255}));
  connect(TOutFixGly.port_b, sinFixGly.ports[1])
    annotation (Line(points={{58,-20},{70,-20}}, color={0,127,255}));

  connect(souGly.ports[1], TInGly.port_a)
    annotation (Line(points={{-70,-60},{-58,-60}}, color={0,127,255}));
  connect(TInGly.port_b, borFieGly.port_a)
    annotation (Line(points={{-38,-60},{-10,-60}}, color={0,127,255}));
  connect(borFieGly.port_b, TOutGly.port_a)
    annotation (Line(points={{10,-60},{38,-60}}, color={0,127,255}));
  connect(TOutGly.port_b, sinGly.ports[1])
    annotation (Line(points={{58,-60},{70,-60}}, color={0,127,255}));

  annotation (
    experiment(StopTime=36000, Tolerance=1e-6),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,120}})),
    Documentation(info="<html>
<p>
This validation model compares outlet temperatures of four single-U-tube
borefield cases: fixed-property water, water with local temperature-dependent
water correlations, fixed-property propylene-glycol/water, and
propylene-glycol/water with local temperature-dependent glycol correlations.
</p>
<p>
A common inlet temperature is used for all cases so the difference between fixed
and temperature-dependent property evaluation is easier to interpret.
</p>
<p>
Only single-U-tube borefields are included because the two-U-tube internal heat
exchanger has not yet been updated with the temperature-dependent property
logic.
</p>
</html>"));
end BorefieldsTDepRconv;
