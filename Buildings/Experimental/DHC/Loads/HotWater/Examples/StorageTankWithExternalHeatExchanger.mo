within Buildings.Experimental.DHC.Loads.HotWater.Examples;
model StorageTankWithExternalHeatExchanger
  "Example model for storage tank with external heat exchanger"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";

  parameter Data.GenericDomesticHotWaterWithHeatExchanger
    datWatHea(
    VTan=0.3, mDom_flow_nominal=0.333)
    "Data for heat pump water heater with tank"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

  Modelica.Blocks.Sources.CombiTimeTable sch(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Heating/DHW/DHW_SingleApartment.mos"),
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Domestic hot water fixture draw fraction schedule"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Fluid.Sources.Boundary_pT sinDis(
    nPorts=1,
    redeclare package Medium = Medium,
    T(displayUnit="degC")) "Sink for heating water"
   annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-4,-50})));
  Fluid.Sources.Boundary_pT souCol(
    nPorts=2,
    redeclare package Medium = Medium,
    T(displayUnit="degC") = 283.15)
              "Source of domestic cold water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-32,-50})));
  Fluid.Sources.MassFlowSource_T souHea(
    use_m_flow_in=true,
    nPorts=1,
    redeclare package Medium = Medium,
    T(displayUnit="degC") = datWatHea.TMix_nominal + datWatHea.dTHexApp_nominal)
    "Source for heating water"
    annotation (
     Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={68,24})));
  Modelica.Blocks.Sources.Constant conTSetHot(k(
      final unit="K",
      displayUnit="degC") = 308.15)
    "Temperature setpoint for hot water supply to fixture"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Experimental.DHC.Loads.HotWater.StorageTankWithExternalHeatExchanger
    domHotWatTan(redeclare package MediumDom = Medium, redeclare package
      MediumHea = Medium,
    dat=datWatHea)        "Storage tank with external heat exchanger"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  ThermostaticMixingValve theMixVal(redeclare package Medium = Medium,
      mMix_flow_nominal=1.2*datWatHea.mDom_flow_nominal)
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToRea(realTrue=0.1*datWatHea.QHex_flow_nominal
        /4200/(55 - 50))
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Modelica.Blocks.Sources.Constant conTSetHot1(k(
      final unit="K",
      displayUnit="degC") = 313.15)
    "Temperature setpoint for hot water supply to fixture"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
equation
  connect(theMixVal.yMixSet, sch.y[1]) annotation (Line(points={{39,78},{-50,78},
          {-50,70},{-59,70}}, color={0,0,127}));
  connect(conTSetHot.y, theMixVal.TMixSet) annotation (Line(points={{-59,40},{
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
  connect(booToRea.y, souHea.m_flow_in) annotation (Line(points={{62,-10},{88,-10},
          {88,16},{80,16}}, color={0,0,127}));
  connect(sinDis.ports[1], domHotWatTan.port_bHea)
    annotation (Line(points={{-4,-40},{-4,24},{0,24}}, color={0,127,255}));
  connect(souHea.ports[1], domHotWatTan.port_aHea)
    annotation (Line(points={{58,24},{20,24}}, color={0,127,255}));
  connect(domHotWatTan.TDomSet, conTSetHot1.y) annotation (Line(points={{-1,30},
          {-20,30},{-20,10},{-59,10}}, color={0,0,127}));
  annotation (Diagram(graphics={
        Text(
          extent={{-140,160},{160,120}},
          textString="%name",
          textColor={0,0,255})}),
    Documentation(info="<html>
<p>
Example model of a fresh water station that heats up domestic hot water.
Input is a load profile which is sent to a model that computes the hot and cold water draw.
If the tank needs to be recharged, then heating water with a prescribed temperature is sent to the tank.
</p>
</html>", revisions="<html>
<ul>
<li>
October 5, 2023, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=8640000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"));
end StorageTankWithExternalHeatExchanger;
