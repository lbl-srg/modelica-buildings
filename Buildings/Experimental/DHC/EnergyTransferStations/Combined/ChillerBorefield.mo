within Buildings.Experimental.DHC.EnergyTransferStations.Combined;
model ChillerBorefield "ETS model for 5GDHC systems with heat recovery chiller and optional borefield"
  extends Buildings.Experimental.DHC.EnergyTransferStations.Combined.BaseClasses.PartialParallel(
    final have_eleCoo=true,
    final have_fan=false,
    redeclare replaceable Buildings.Experimental.DHC.EnergyTransferStations.Combined.Controls.Supervisory conSup
      constrainedby Buildings.Experimental.DHC.EnergyTransferStations.Combined.Controls.Supervisory(
        final controllerType=controllerType,
        final kHot=kHot,
        final kCol=kCol,
        final TiHot=TiHot,
        final TiCol=TiCol,
        final THeaWatSupSetMin=THeaWatSupSetMin,
        final TChiWatSupSetMin=TChiWatSupSetMin),
    nSysHea=1,
    nSouAmb=
      if have_borFie then
        2
      else
        1,
    VTanHeaWat=datChi.PLRMin*datChi.mCon_flow_nominal*5*60/1000,
    VTanChiWat=datChi.PLRMin*datChi.mEva_flow_nominal*5*60/1000,
    colChiWat(
      mCon_flow_nominal={colAmbWat.mDis_flow_nominal,datChi.mEva_flow_nominal}),
    colHeaWat(
      mCon_flow_nominal={colAmbWat.mDis_flow_nominal,datChi.mCon_flow_nominal}),
    colAmbWat(
      mCon_flow_nominal=
        if have_borFie then
          {hex.m2_flow_nominal,datBorFie.conDat.mBorFie_flow_nominal}
        else
          {hex.m2_flow_nominal}),
    totPPum(
      nin=3),
    totPHea(
      nin=1),
    totPCoo(
      nin=1),
    nPorts_bChiWat=1,
    nPorts_aHeaWat=1,
    nPorts_aChiWat=1,
    nPorts_bHeaWat=1);
  parameter Boolean have_borFie=false
    "Set to true in case a borefield is used in addition of the district HX"
    annotation (Evaluate=true);
  parameter Boolean have_WSE=false
    "Set to true in case a waterside economizer is used"
    annotation (Evaluate=true);
  parameter Modelica.Units.SI.PressureDifference dpCon_nominal(displayUnit="Pa")
    "Nominal pressure drop accross condenser"
    annotation (Dialog(group="Chiller"));
  parameter Modelica.Units.SI.PressureDifference dpEva_nominal(displayUnit="Pa")
    "Nominal pressure drop accross evaporator"
    annotation (Dialog(group="Chiller"));
  replaceable parameter Fluid.Chillers.Data.ElectricEIR.Generic datChi
    "Chiller performance data"
    annotation (Dialog(group="Chiller"),choicesAllMatching=true,
    Placement(transformation(extent={{20,222},{40,242}})));
  parameter Modelica.Units.SI.PressureDifference dp1WSE_nominal(displayUnit=
        "Pa") = 40E3
    "Nominal pressure drop across heat exchanger on district side"
    annotation (Dialog(group="Waterside economizer", enable=have_WSE));
  parameter Modelica.Units.SI.PressureDifference dp2WSE_nominal(displayUnit=
        "Pa") = 40E3
    "Nominal pressure drop across heat exchanger on building side"
    annotation (Dialog(group="Waterside economizer", enable=have_WSE));
  parameter Modelica.Units.SI.HeatFlowRate QWSE_flow_nominal=0
    "Nominal heat flow rate through heat exchanger (<=0)"
    annotation (Dialog(group="Waterside economizer", enable=have_WSE));
  parameter Modelica.Units.SI.Temperature T_a1WSE_nominal=279.15
    "Nominal water inlet temperature on district side"
    annotation (Dialog(group="Waterside economizer", enable=have_WSE));
  parameter Modelica.Units.SI.Temperature T_b1WSE_nominal=284.15
    "Nominal water outlet temperature on district side"
    annotation (Dialog(group="Waterside economizer", enable=have_WSE));
  parameter Modelica.Units.SI.Temperature T_a2WSE_nominal=288.15
    "Nominal water inlet temperature on building side"
    annotation (Dialog(group="Waterside economizer", enable=have_WSE));
  parameter Modelica.Units.SI.Temperature T_b2WSE_nominal=281.15
    "Nominal water outlet temperature on building side"
    annotation (Dialog(group="Waterside economizer", enable=have_WSE));
  parameter Real y1WSEMin(unit="1")=0.05
    "Minimum pump flow rate or valve opening for temperature measurement (fractional)"
    annotation (Dialog(group="Waterside economizer", enable=have_WSE));
  final parameter Modelica.Units.SI.MassFlowRate m1WSE_flow_nominal=abs(
      QWSE_flow_nominal/4200/(T_b1WSE_nominal - T_a1WSE_nominal))
    "WSE primary mass flow rate"
    annotation (Dialog(group="Waterside economizer", enable=have_WSE));
  parameter Modelica.Units.SI.Temperature TBorWatEntMax=313.15
    "Maximum value of borefield water entering temperature"
    annotation (Dialog(group="Borefield", enable=have_borFie));
  parameter Real spePumBorMin(unit="1")=0.1
    "Borefield pump minimum speed"
    annotation (Dialog(group="Borefield",enable=have_borFie));
  parameter Modelica.Units.SI.Pressure dpBorFie_nominal(displayUnit="Pa") = 5E4
    "Pressure losses for the entire borefield (control valve excluded)"
    annotation (Dialog(group="Borefield", enable=have_borFie));
  replaceable parameter Fluid.Geothermal.Borefields.Data.Borefield.Example datBorFie
    constrainedby Fluid.Geothermal.Borefields.Data.Borefield.Template
    "Borefield parameters"
    annotation (Dialog(group="Borefield",enable=have_borFie),
    choicesAllMatching=true,Placement(transformation(extent={{140,222},{160,242}})));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="Supervisory controller"));
  parameter Real kHot(
    min=0)=0.05
    "Gain of controller on hot side"
    annotation (Dialog(group="Supervisory controller"));
  parameter Real kCol(
    min=0)=0.1
    "Gain of controller on cold side"
    annotation (Dialog(group="Supervisory controller"));
  parameter Modelica.Units.SI.Time TiHot(min=Buildings.Controls.OBC.CDL.Constants.small)
     = 300 "Time constant of integrator block on hot side" annotation (Dialog(
        group="Supervisory controller", enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
           or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.Units.SI.Time TiCol(min=Buildings.Controls.OBC.CDL.Constants.small)
     = 120 "Time constant of integrator block on cold side" annotation (Dialog(
        group="Supervisory controller", enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
           or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.Units.SI.Temperature THeaWatSupSetMin(displayUnit="degC")
     = datChi.TConEntMin + 5
    "Minimum value of heating water supply temperature set point"
    annotation (Dialog(group="Supervisory controller"));
  parameter Modelica.Units.SI.Temperature TChiWatSupSetMin(displayUnit="degC")
     = datChi.TEvaLvgMin
    "Minimum value of chilled water supply temperature set point"
    annotation (Dialog(group="Supervisory controller"));

  replaceable
    Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.Chiller
    chi(
    redeclare final package Medium = MediumBui,
    final dpCon_nominal=dpCon_nominal,
    final dpEva_nominal=dpEva_nominal,
    final dat=datChi) "Chiller" annotation (Dialog(group="Chiller"), Placement(
        transformation(extent={{-10,-16},{10,4}})));
  replaceable
    Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.Borefield
    borFie(
    redeclare final package Medium = MediumBui,
    final datBorFie=datBorFie,
    final TBorWatEntMax=TBorWatEntMax,
    final spePumBorMin=spePumBorMin,
    final dp_nominal=dpBorFie_nominal) if have_borFie "Borefield" annotation (
      Dialog(group="Borefield", enable=have_borFie), Placement(transformation(
          extent={{-80,-230},{-60,-210}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zerPPum(
    final k=0) if not have_borFie
    "Zero power"
    annotation (Placement(transformation(extent={{220,-90},{240,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zerPHea(
    final k=0)
    "Zero power"
    annotation (Placement(transformation(extent={{220,50},{240,70}})));
  Buildings.Experimental.DHC.Networks.BaseClasses.DifferenceEnthalpyFlowRate dHFloHeaWat(
    redeclare final package Medium1 = MediumBui,
    final m_flow_nominal=colHeaWat.mDis_flow_nominal)
    "Variation of enthalpy flow rate"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-274,130})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dHHeaWat_flow(final unit="W")
    "Heating water distributed energy flow rate"
    annotation (Placement(transformation(extent={{300,140},{340,180}}),
      iconTransformation(extent={{-40,-40},{40,40}},
        rotation=-90,
        origin={240,-340})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dHChiWat_flow(final unit="W")
    "Chilled water distributed energy flow rate"
    annotation (Placement(transformation(extent={{300,100},{340,140}}),
      iconTransformation(extent={{-40,-40},{40,40}},
        rotation=-90,
        origin={280,-340})));
  Buildings.Experimental.DHC.Networks.BaseClasses.DifferenceEnthalpyFlowRate dHFloChiWat(
    redeclare final package Medium1 = MediumBui,
    final m_flow_nominal=colChiWat.mDis_flow_nominal)
    "Variation of enthalpy flow rate"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=90,
        origin={274,130})));
  Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.WatersideEconomizer
    WSE(
    redeclare final package Medium1 = MediumSer,
    redeclare final package Medium2 = MediumBui,
    final allowFlowReversal1=allowFlowReversalSer,
    final allowFlowReversal2=allowFlowReversalBui,
    final conCon=conCon,
    final dp1Hex_nominal=dp1WSE_nominal,
    final dp2Hex_nominal=dp2WSE_nominal,
    final Q_flow_nominal=QWSE_flow_nominal,
    final T_a1_nominal=T_a1WSE_nominal,
    final T_b1_nominal=T_b1WSE_nominal,
    final T_a2_nominal=T_a2WSE_nominal,
    final T_b2_nominal=T_b2WSE_nominal,
    final y1Min=y1WSEMin) if have_WSE "Waterside economizer"
    annotation (Placement(transformation(extent={{220,116},{240,136}})));
  Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.Junction splWSE(
    redeclare final package Medium = MediumSer,
    final m_flow_nominal={
      hex.m1_flow_nominal + m1WSE_flow_nominal,
      -hex.m1_flow_nominal,
      -m1WSE_flow_nominal})
    "Flow splitter for WSE"
    annotation (Placement(transformation(extent={{-230,-270},{-210,-250}})));
  Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.Junction mixWSE(
    redeclare final package Medium = MediumSer,
    final m_flow_nominal={
      hex.m1_flow_nominal,
      -hex.m1_flow_nominal - m1WSE_flow_nominal,
      m1WSE_flow_nominal})
    "Flow mixer for WSE"
    annotation (Placement(transformation(extent={{244,-250},{264,-270}})));

equation
  if not have_WSE then
    connect(tanChiWat.port_aTop, dHFloChiWat.port_b2)
    annotation (Line(points={{200,112},{268,112},{268,120}}, color={0,127,255}));
  end if;

  connect(chi.port_bHeaWat,colHeaWat.ports_aCon[2])
    annotation (Line(points={{10,0},{20,0},{20,10},{-108,10},{-108,-24}},color={0,127,255}));
  connect(chi.port_aHeaWat,colHeaWat.ports_bCon[2])
    annotation (Line(points={{-10,0},{-132,0},{-132,-24}},color={0,127,255}));
  connect(chi.port_bChiWat,colChiWat.ports_aCon[2])
    annotation (Line(points={{-10,-12},{-20,-12},{-20,-20},{108,-20},{108,-24}},color={0,127,255}));
  connect(colChiWat.ports_bCon[2],chi.port_aChiWat)
    annotation (Line(points={{132,-24},{132,-12},{10,-12}},color={0,127,255}));
  connect(conSup.TChiWatSupSet,chi.TChiWatSupSet)
    annotation (Line(points={{-238,17},{-26,17},{-26,-8},{-12,-8}},color={0,0,127}));
  connect(chi.PPum,totPPum.u[2])
    annotation (Line(points={{12,-8},{30,-8},{30,-58},{258,-58},{258,-60}},color={0,0,127}));
  connect(colAmbWat.ports_aCon[2],borFie.port_b)
    annotation (Line(points={{12,-116},{14,-116},{14,-220},{-60,-220}},color={0,127,255}));
  connect(colAmbWat.ports_bCon[2],borFie.port_a)
    annotation (Line(points={{-12,-116},{-14,-116},{-14,-140},{-100,-140},{-100,-220},{-80,-220}},color={0,127,255}));
  connect(conSup.yAmb[1],borFie.u)
    annotation (Line(points={{-238,25},{-200,25},{-200,-212},{-82,-212}},color={0,0,127}));
  connect(valIsoCon.y_actual,borFie.yValIso_actual[1])
    annotation (Line(points={{-55,-113},{-40,-113},{-40,-198},{-90,-198},{-90,
          -216.5},{-82,-216.5}},                                                                color={0,0,127}));
  connect(valIsoEva.y_actual,borFie.yValIso_actual[2])
    annotation (Line(points={{55,-113},{40,-113},{40,-200},{-88,-200},{-88,
          -215.5},{-82,-215.5}},                                                             color={0,0,127}));
  connect(borFie.PPum,totPPum.u[3])
    annotation (Line(points={{-58,-216},{250,-216},{250,-62},{258,-62},{258,-60}},color={0,0,127}));
  connect(zerPPum.y,totPPum.u[3])
    annotation (Line(points={{242,-80},{248,-80},{248,-60},{258,-60}},          color={0,0,127}));
  connect(zerPHea.y,totPHea.u[1])
    annotation (Line(points={{242,60},{258,60}},color={0,0,127}));
  connect(chi.PChi,totPCoo.u[1])
    annotation (Line(points={{12,-4},{30,-4},{30,20},{258,20}},color={0,0,127}));
  connect(uHea,conSup.uHea)
    annotation (Line(points={{-320,100},{-290,100},{-290,31},{-262,31}},color={255,0,255}));
  connect(conSup.yHea,chi.uHea)
    annotation (Line(points={{-238,31},{-20,31},{-20,-2},{-12,-2}},color={255,0,255}));
  connect(conSup.yCoo,chi.uCoo)
    annotation (Line(points={{-238,29},{-22,29},{-22,-4},{-12,-4}},color={255,0,255}));
  connect(valIsoCon.y_actual,conSup.yValIsoCon_actual)
    annotation (Line(points={{-55,-113},{-40,-113},{-40,-60},{-266,-60},{-266,15},
          {-262,15}},                                                                        color={0,0,127}));
  connect(valIsoEva.y_actual,conSup.yValIsoEva_actual)
    annotation (Line(points={{55,-113},{40,-113},{40,-64},{-270,-64},{-270,13},{
          -262,13}},                                                                      color={0,0,127}));
  connect(dHFloHeaWat.dH_flow,dHHeaWat_flow)
    annotation (Line(points={{-271,142},{-271,160},{320,160}},           color={0,0,127}));
  connect(dHFloChiWat.dH_flow,dHChiWat_flow)
    annotation (Line(points={{277,142},{292,142},{292,120},{320,120}},color={0,0,127}));
  connect(dHFloChiWat.port_a1, tanChiWat.port_bBot)
    annotation (Line(points={{280,120},{280,100},{200,100}},           color={0,127,255}));
  connect(dHFloChiWat.port_b1, ports_bChiWat[1])
    annotation (Line(points={{280,140},{280,200},{300,200}},                               color={0,127,255}));
  connect(tanHeaWat.port_bTop, dHFloHeaWat.port_a1)
    annotation (Line(points={{-220,112},{-268,112},{-268,120}},
                                                     color={0,127,255}));
  connect(tanHeaWat.port_aBot, dHFloHeaWat.port_b2)
    annotation (Line(points={{-220,100},{-280,100},{-280,120}},
                                                     color={0,127,255}));
  connect(dHFloHeaWat.port_a2, ports_aHeaWat[1])
    annotation (Line(points={{-280,140},{-280,260},{-300,260}},            color={0,127,255}));
  connect(ports_aChiWat[1], dHFloChiWat.port_a2)
    annotation (Line(points={{-300,200},{268,200},{268,140}},             color={0,127,255}));
  connect(dHFloHeaWat.port_b1, ports_bHeaWat[1])
    annotation (Line(points={{-268,140},{-268,260},{300,260}},            color={0,127,255}));
  connect(splWSE.port_2, hex.port_a1) annotation (Line(points={{-210,-260},{-10,
          -260}},                                                                       color={0,127,255}));
  connect(dHFloChiWat.port_b2, WSE.port_a2)
    annotation (Line(points={{268,120},{240,120}},                     color={0,127,255}));
  connect(WSE.port_b2, tanChiWat.port_aTop) annotation (Line(points={{220,120},{206,120},{206,112},{200,112}},
                                                                                           color={0,127,255}));
  connect(mixWSE.port_2, port_bSerAmb)
    annotation (Line(points={{264,-260},{280,-260},{280,-200},{300,-200}}, color={0,127,255}));
  connect(splWSE.port_3, WSE.port_a1)
    annotation (Line(points={{-220,-270},{-220,-280},{210,-280},{210,132},{220,132}}, color={0,127,255}));
  connect(WSE.port_b1, mixWSE.port_3) annotation (Line(points={{240,132},{254,132},{254,-250}}, color={0,127,255}));
  connect(hex.port_b1, mixWSE.port_1) annotation (Line(points={{10,-260},{244,-260}}, color={0,127,255}));
  connect(conSup.yCoo, WSE.uCoo) annotation (Line(points={{-238,29},{140,29},{140,
          126},{218,126}},                                                                         color={255,0,255}));
  connect(valIsoEva.y_actual, WSE.yValIsoEva_actual)
    annotation (Line(points={{55,-113},{40,-113},{40,123},{218,123}}, color={0,0,127}));
  connect(port_aSerAmb, splWSE.port_1) annotation (Line(points={{-300,-200},{
          -280,-200},{-280,-260},{-230,-260}}, color={0,127,255}));
  annotation (
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-300,-300},{300,300}}),
      graphics={
        Line(
          points={{86,92}},
          color={28,108,200},
          pattern=LinePattern.Dash)}),
    defaultComponentName="ets",
    Documentation(
      revisions="<html>
<ul>
<li>
March 27, 2024, by David Blum:<br/>
Update icon.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3606\">issue #3606</a>.
</li>
<li>
April 30, 2021, by Michael Wetter:<br/>
Reformulated replaceable class to avoid access of components that are not in the constraining type.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2471\">issue #2471</a>.
</li>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This model represents an energy transfer station as illustrated in the schematics
below.
</p>
<ul>
<li>
The heating and cooling functions are provided by a heat recovery chiller, see
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.Chiller\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.Chiller</a>
for the operating principles and modeling assumptions.
The condenser and evaporator loops are equipped with constant speed pumps.
</li>
<li>
The supervisory controller ensures the load balancing between the condenser side
and the evaporator side of the chiller by controlling in sequence an optional
geothermal borefield (priority system), the district heat exchanger (second
priority system), and ultimately the chiller, by resetting down the chilled
water supply temperature, see
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Controls.Supervisory\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Controls.Supervisory</a>
for a detailed description.
The borefield and district heat exchanger loops are equipped with
variable speed pumps modulated by the supervisory controller.
</li>
</ul>
<p>
Note that the heating and cooling enable signals (<code>uHea</code> and <code>uCoo</code>)
connected to this model should be switched to <code>false</code> when the
building has no corresponding demand (e.g., based on the requests yielded by
the terminal unit controllers, in conjunction with a schedule).
This will significantly improve the system performance as it is a
necessary condition for the chiller to be operated at a lower lift, see
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Controls.Reset\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Controls.Reset</a>.
<br/>
</p>
<p align=\"center\">
<img alt=\"System schematics\"
src=\"modelica://Buildings/Resources/Images/Experimental/DHC/EnergyTransferStations/Combined/ChillerBorefield.png\"/>
</p>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-234,62},{-92,-64}},
          lineColor={0,0,0},
          fillColor={234,210,210},
          fillPattern=FillPattern.Solid,
          visible=have_borFie),
        Ellipse(
          extent={{-222,-4},{-166,-60}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward,
          visible=have_borFie),
        Ellipse(
          extent={{-216,-10},{-172,-54}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward,
          visible=have_borFie),
        Ellipse(
          extent={{-222,56},{-166,0}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward,
          visible=have_borFie),
        Ellipse(
          extent={{-216,50},{-172,6}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward,
          visible=have_borFie),
        Ellipse(
          extent={{-160,56},{-104,0}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward,
          visible=have_borFie),
        Ellipse(
          extent={{-154,50},{-110,6}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward,
          visible=have_borFie),
        Ellipse(
          extent={{-162,-4},{-106,-60}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward,
          visible=have_borFie),
        Ellipse(
          extent={{-156,-10},{-112,-54}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward,
          visible=have_borFie),
        Rectangle(
          extent={{24,-42},{52,-14}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-64,32},{-62,22}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-1.5,5.5},{1.5,-5.5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={-7.5,22.5},
          rotation=90),
        Rectangle(
          extent={{116,-46},{144,-18}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=have_WSE),
        Rectangle(
          extent={{118,-44},{146,-16}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=have_WSE),
        Rectangle(
          extent={{-68,78},{72,-82}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-42,50},{-38,10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-54,68},{60,50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-40,0},{-50,10},{-30,10},{-40,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-40,0},{-50,-12},{-30,-12},{-40,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-42,-12},{-38,-52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{40,50},{44,-52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-54,-52},{60,-70}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{20,22},{64,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{42,22},{24,-10},{60,-10},{42,22}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-42,50},{-38,10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-54,68},{60,50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-40,0},{-50,10},{-30,10},{-40,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-40,0},{-50,-12},{-30,-12},{-40,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-42,-12},{-38,-52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{40,50},{44,-52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-54,-52},{60,-70}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{20,22},{64,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{42,22},{24,-10},{60,-10},{42,22}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{100,76},{240,-84}},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          visible=have_WSE),  Rectangle(
          extent={{100,74},{240,-84}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          visible=have_WSE),  Rectangle(
          extent={{100,74},{240,-86}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          visible=have_WSE),
        Rectangle(
          extent={{108,56},{120,-62}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=have_WSE),
        Rectangle(
          extent={{120,56},{136,-62}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          visible=have_WSE),
        Rectangle(
          extent={{148,56},{164,-62}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          visible=have_WSE),
        Rectangle(
          extent={{136,56},{148,-62}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=have_WSE),
        Rectangle(
          extent={{176,56},{192,-62}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          visible=have_WSE),
        Rectangle(
          extent={{164,56},{176,-62}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=have_WSE),
        Rectangle(
          extent={{204,56},{220,-62}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          visible=have_WSE),
        Rectangle(
          extent={{192,56},{204,-62}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=have_WSE),
        Rectangle(
          extent={{220,56},{232,-62}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=have_WSE),
        Rectangle(extent={{-256,140},{264,-142}}, lineColor={95,95,95})}));
end ChillerBorefield;
