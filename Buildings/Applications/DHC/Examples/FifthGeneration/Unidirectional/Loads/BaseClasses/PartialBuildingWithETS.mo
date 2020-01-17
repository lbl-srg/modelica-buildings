within Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.Loads.BaseClasses;
partial model PartialBuildingWithETS
  "Partial model of a building with an energy transfer station"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    final m_flow_nominal=max(
      ets.m1HexChi_flow_nominal, ets.mEva_flow_nominal),
    final m_flow_small=1E-4*m_flow_nominal,
    final show_T=false,
    final allowFlowReversal=false);
  parameter Integer nSup = 2
    "Number of supply lines"
    annotation(Dialog(group="ETS model parameters"), Evaluate=true);
  parameter Modelica.SIunits.TemperatureDifference dT_nominal=5
    "Water temperature drop/increase accross load and source-side HX (always positive)"
    annotation(Dialog(group="ETS model parameters"));
  parameter Modelica.SIunits.Temperature TChiWatSup_nominal=273.15 + 18
    "Chilled water supply temperature"
    annotation(Dialog(group="ETS model parameters"));
  parameter Modelica.SIunits.Temperature TChiWatRet_nominal=
     TChiWatSup_nominal + dT_nominal
     "Chilled water return temperature"
     annotation(Dialog(group="ETS model parameters"));
  parameter Modelica.SIunits.Temperature THeaWatSup_nominal=273.15 + 40
    "Heating water supply temperature"
    annotation(Dialog(group="ETS model parameters"));
  parameter Modelica.SIunits.Temperature THeaWatRet_nominal=
     THeaWatSup_nominal - dT_nominal
     "Heating water return temperature"
     annotation(Dialog(group="ETS model parameters"));
  parameter Modelica.SIunits.Pressure dp_nominal=50000
    "Pressure difference at nominal flow rate (for each flow leg)"
    annotation(Dialog(group="ETS model parameters"));
  parameter Real COP_nominal=5
    "Heat pump COP"
    annotation(Dialog(group="ETS model parameters"));
  // IO CONNECTORS
  Modelica.Blocks.Interfaces.RealInput TSetChiWat
    "Chilled water set point"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,40}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,40})));
  Modelica.Blocks.Interfaces.RealInput TSetHeaWat
    "Heating water set point"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,70}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,80})));
  // COMPONENTS
  replaceable Buildings.Applications.DHC.Loads.BaseClasses.PartialBuilding bui(
    redeclare package Medium1=Medium,
    nPorts1=nSup)
    "Building"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  replaceable EnergyTransferStation.ETSSimplified ets(
    redeclare package Medium = Medium,
    nSup=nSup,
    QCoo_flow_nominal=sum(bui.terUni.QCoo_flow_nominal),
    QHea_flow_nominal=sum(bui.terUni.QHea_flow_nominal),
    dT_nominal=dT_nominal,
    TChiWatSup_nominal=TChiWatSup_nominal,
    TChiWatRet_nominal=TChiWatRet_nominal,
    THeaWatSup_nominal=THeaWatSup_nominal,
    THeaWatRet_nominal=THeaWatRet_nominal,
    dp_nominal=dp_nominal,
    COP_nominal=COP_nominal) "Energy transfer station"
    annotation (Placement(transformation(extent={{-20,-60},{20,-20}})));
equation
  connect(port_a, ets.port_a) annotation (Line(points={{-100,0},{-80,0},{-80,-40},
          {-20,-40}}, color={0,127,255}));
  connect(ets.port_b, port_b) annotation (Line(points={{20,-40},{80,-40},{80,0},
          {100,0}},    color={0,127,255}));
  connect(TSetChiWat, ets.TSetChiWat) annotation (Line(points={{-120,40},{-74,
          40},{-74,-28.5714},{-21.4286,-28.5714}},
                                               color={0,0,127}));
  connect(TSetHeaWat, ets.TSetHeaWat) annotation (Line(points={{-120,70},{-68,
          70},{-68,-22.8571},{-21.4286,-22.8571}},
                                               color={0,0,127}));
  connect(bui.ports_b1[1:2], ets.ports_a1) annotation (Line(points={{10,44},{60,
          44},{60,0},{-40,0},{-40,-52.8571},{-20,-52.8571}}, color={0,127,255}));
  connect(ets.ports_b1, bui.ports_a1[1:2]) annotation (Line(points={{20,
          -52.8571},{28,-52.8571},{40,-52.8571},{40,-80},{-60,-80},{-60,44},{
          -10,44}},
        color={0,127,255}));
  annotation (
    DefaultComponentName="bui",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-60,-34},{0,-28}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,-34},{0,-40}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,-40},{60,-34}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,-28},{60,-34}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{60,6},{100,0}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,0},{-60,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,0},{-60,6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{60,-6},{100,0}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
      Polygon(
        points={{0,80},{-40,60},{40,60},{0,80}},
        lineColor={95,95,95},
        smooth=Smooth.None,
        fillPattern=FillPattern.Solid,
        fillColor={95,95,95}),
      Rectangle(
          extent={{-40,60},{40,-40}},
          lineColor={150,150,150},
          fillPattern=FillPattern.Sphere,
          fillColor={255,255,255}),
      Rectangle(
        extent={{-30,30},{-10,50}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{10,30},{30,50}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-30,-10},{-10,10}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{10,-10},{30,10}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,0}),
        Rectangle(
          extent={{-20,-3},{20,3}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          origin={63,-20},
          rotation=90),
        Rectangle(
          extent={{-19,3},{19,-3}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-63,-21},
          rotation=90),
        Rectangle(
          extent={{-19,-3},{19,3}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          origin={-57,-13},
          rotation=90),
        Rectangle(
          extent={{-19,3},{19,-3}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={57,-13},
          rotation=90)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialBuildingWithETS;
