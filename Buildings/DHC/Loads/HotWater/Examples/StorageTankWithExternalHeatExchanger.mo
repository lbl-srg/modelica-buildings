within Buildings.DHC.Loads.HotWater.Examples;
model StorageTankWithExternalHeatExchanger
  "Example model for storage tank with external heat exchanger"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Medium model";
  parameter Modelica.Units.SI.Temperature TCol = 273.15+10 "Temperature of domestic cold water supply";
  parameter Modelica.Units.SI.MassFlowRate mHea_flow_nominal = datWatHea.QHex_flow_nominal/4200/(55 - 50) "Tank heater water loop nominal mass flow";
  parameter Buildings.DHC.Loads.HotWater.Data.GenericDomesticHotWaterWithHeatExchanger
    datWatHea(VTan=0.1892706, mDom_flow_nominal=6.52944E-06*1000)
    "Data for heat pump water heater with tank"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

  Modelica.Blocks.Sources.CombiTimeTable sch(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/HotWater/DHW_ApartmentMidRise.mos"),
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Domestic hot water fixture draw fraction schedule"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Buildings.Fluid.Sources.Boundary_pT souCol(
    nPorts=2,
    redeclare package Medium = Medium,
    T(displayUnit="degC") = 283.15) "Source of domestic cold water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-32,-50})));
  Modelica.Blocks.Sources.Constant conTSetMix(k(
      final unit="K",
      displayUnit="degC") = 308.15)
    "Temperature setpoint for mixed water supply to fixture"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.DHC.Loads.HotWater.StorageTankWithExternalHeatExchanger
    domHotWatTan(redeclare package MediumDom = Medium, redeclare package
      MediumHea = Medium,
    dat=datWatHea)        "Storage tank with external heat exchanger"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.DHC.Loads.HotWater.ThermostaticMixingValve theMixVal(redeclare
      package                                                                                   Medium = Medium,
      mMix_flow_nominal=1.2*datWatHea.mDom_flow_nominal)
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(realTrue=
        mHea_flow_nominal)
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Modelica.Blocks.Sources.Constant conTSetHot(k(
      final unit="K",
      displayUnit="degC") = 313.15)
    "Temperature setpoint for hot water supply to fixture"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Fluid.HeatExchangers.Heater_T hea(
    redeclare package Medium = Medium,
    m_flow_nominal=mHea_flow_nominal,
    dp_nominal=0)
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow mov(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=mHea_flow_nominal)
    annotation (Placement(transformation(extent={{70,14},{50,34}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = Medium,
    m_flow_nominal=mHea_flow_nominal,
    tau=0) annotation (Placement(transformation(extent={{10,-50},{30,-30}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(p=5) "dT for heater"
    annotation (Placement(transformation(extent={{14,-24},{24,-14}})));
  Buildings.Fluid.Sources.Boundary_pT preRef(
    nPorts=1,
    redeclare package Medium = Medium,
    T(displayUnit="degC")) "Reference pressure" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,-60})));
equation
  connect(theMixVal.yMixSet, sch.y[1]) annotation (Line(points={{39,78},{-50,78},
          {-50,70},{-59,70}}, color={0,0,127}));
  connect(conTSetMix.y, theMixVal.TMixSet) annotation (Line(points={{-59,40},{
          -10,40},{-10,72},{39,72}},
                                 color={0,0,127}));
  connect(domHotWatTan.port_bDom, theMixVal.port_hot) annotation (Line(points={{
          20,36},{32,36},{32,66},{40,66}}, color={0,127,255}));
  connect(souCol.ports[1], domHotWatTan.port_aDom)
    annotation (Line(points={{-31,-40},{-31,36},{0,36}}, color={0,127,255}));
  connect(souCol.ports[2], theMixVal.port_col)
    annotation (Line(points={{-33,-40},{-33,62},{40,62}}, color={0,127,255}));
  connect(booToRea.u, domHotWatTan.charge) annotation (Line(points={{38,-10},{32,
          -10},{32,21},{22,21}}, color={255,0,255}));
  connect(domHotWatTan.TDomSet, conTSetHot.y) annotation (Line(points={{-1,30},{
          -20,30},{-20,10},{-59,10}}, color={0,0,127}));
  connect(mov.port_b, domHotWatTan.port_aHea)
    annotation (Line(points={{50,24},{20,24}}, color={0,127,255}));
  connect(hea.port_b, mov.port_a) annotation (Line(points={{60,-40},{80,-40},{80,
          24},{70,24}}, color={0,127,255}));
  connect(booToRea.y, mov.m_flow_in) annotation (Line(points={{62,-10},{90,-10},
          {90,46},{60,46},{60,36}}, color={0,0,127}));
  connect(domHotWatTan.port_bHea, senTem.port_a) annotation (Line(points={{0,24},
          {-10,24},{-10,-40},{10,-40}}, color={0,127,255}));
  connect(senTem.port_b, hea.port_a)
    annotation (Line(points={{30,-40},{40,-40}}, color={0,127,255}));
  connect(addPar.y, hea.TSet) annotation (Line(points={{25,-19},{32,-19},{32,-32},
          {38,-32}}, color={0,0,127}));
  connect(senTem.T, addPar.u) annotation (Line(points={{20,-29},{14,-29},{14,-28},
          {6,-28},{6,-19},{13,-19}}, color={0,0,127}));
  connect(hea.port_b, preRef.ports[1])
    annotation (Line(points={{60,-40},{80,-40},{80,-50}}, color={0,127,255}));
  annotation (Diagram(graphics={
        Text(
          extent={{-140,160},{160,120}},
          textString="%name",
          textColor={0,0,255})}),
          __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/DHC/Loads/HotWater/Examples/StorageTankWithExternalHeatExchanger.mos" "Simulate and plot"),
Documentation(info="<html>
<p>
Example model of a fresh water station that heats up domestic hot water.
Input is a load profile which is sent to a model that computes the hot and cold water draw.
If the tank needs to be recharged, then tank water is circulated through a heater
with a prescribed temperature lift.
</p>
</html>", revisions="<html>
<ul>
<li>
November 15, 2023, by David Blum:<br/>
Add heater with constant dT as heat source.
</li>
<li>
October 5, 2023, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=172800,
      Tolerance=1e-06));
end StorageTankWithExternalHeatExchanger;
