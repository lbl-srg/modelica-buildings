within Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5;
model ChillerBorefield
  "ETS model for 5GDHC systems with heat recovery chiller and optional borefield"
  extends Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.BaseClasses.PartialParallel(
    final have_eleCoo=true,
    final have_fan=false,
    redeclare replaceable Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.Supervisory conSup
      constrainedby Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.Supervisory(
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
    dT1HexSet=abs(
      T_b1Hex_nominal-T_a1Hex_nominal) .* {1+1/datChi.COP_nominal,1},
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
      nin=1));
  parameter Boolean have_borFie=false
    "Set to true in case a borefield is used in addition of the district HX"
    annotation (Evaluate=true);
  parameter Modelica.SIunits.PressureDifference dpCon_nominal(
    displayUnit="Pa")
    "Nominal pressure drop accross condenser"
    annotation (Dialog(group="Chiller"));
  parameter Modelica.SIunits.PressureDifference dpEva_nominal(
    displayUnit="Pa")
    "Nominal pressure drop accross evaporator"
    annotation (Dialog(group="Chiller"));
  replaceable parameter Fluid.Chillers.Data.ElectricEIR.Generic datChi
    "Chiller performance data"
    annotation (Dialog(group="Chiller"),choicesAllMatching=true,
    Placement(transformation(extent={{20,222},{40,242}})));
  replaceable parameter Buildings.Fluid.Movers.Data.Generic perPumCon(
    motorCooledByFluid=false)
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Record with performance data for condenser pump"
    annotation (Dialog(group="Chiller"),choicesAllMatching=true,
    Placement(transformation(extent={{60,222},{80,242}})));
  replaceable parameter Buildings.Fluid.Movers.Data.Generic perPumEva(
    motorCooledByFluid=false)
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Record with performance data for evaporator pump"
    annotation (Dialog(group="Chiller"),choicesAllMatching=true,
    Placement(transformation(extent={{100,222},{120,242}})));
  parameter Modelica.SIunits.Temperature TBorWatEntMax=313.15
    "Maximum value of borefield water entering temperature"
    annotation (Dialog(group="Borefield",enable=have_borFie));
  parameter Real spePumBorMin(
    final unit="1")=0.1
    "Borefield pump minimum speed"
    annotation (Dialog(group="Borefield",enable=have_borFie));
  parameter Modelica.SIunits.Pressure dpBorFie_nominal(
    displayUnit="Pa")=5E4
    "Pressure losses for the entire borefield (control valve excluded)"
    annotation (Dialog(group="Borefield",enable=have_borFie));
  replaceable parameter Fluid.Geothermal.Borefields.Data.Borefield.Example datBorFie
    constrainedby Fluid.Geothermal.Borefields.Data.Borefield.Template
    "Borefield parameters"
    annotation (Dialog(group="Borefield",enable=have_borFie),
    choicesAllMatching=true,Placement(transformation(extent={{140,222},{160,242}})));
  replaceable parameter Buildings.Fluid.Movers.Data.Generic perPumBorFie(
    motorCooledByFluid=false)
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Record with performance data for borefield pump"
    annotation (Dialog(group="Borefield",enable=have_borFie),
    choicesAllMatching=true,Placement(transformation(extent={{180,222},{200,242}})));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
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
  parameter Modelica.SIunits.Time TiHot(
    min=Buildings.Controls.OBC.CDL.Constants.small)=300
    "Time constant of integrator block on hot side"
    annotation (Dialog(group="Supervisory controller",
    enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
    controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.SIunits.Time TiCol(
    min=Buildings.Controls.OBC.CDL.Constants.small)=120
    "Time constant of integrator block on cold side"
    annotation (Dialog(group="Supervisory controller",enable=controllerType ==
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
    controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.SIunits.Temperature THeaWatSupSetMin(
    displayUnit="degC")=datChi.TConEntMin+5
    "Minimum value of heating water supply temperature set point"
    annotation (Dialog(group="Supervisory controller"));
  parameter Modelica.SIunits.Temperature TChiWatSupSetMin(
    displayUnit="degC")=datChi.TEvaLvgMin
    "Minimum value of chilled water supply temperature set point"
    annotation (Dialog(group="Supervisory controller"));
  replaceable Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Subsystems.Chiller chi(
    redeclare final package Medium=MediumBui,
    final perPumCon=perPumCon,
    final perPumEva=perPumEva,
    final dpCon_nominal=dpCon_nominal,
    final dpEva_nominal=dpEva_nominal,
    final dat=datChi)
    "Chiller"
    annotation (Dialog(group="Chiller"),Placement(transformation(extent={{-10,-16},{10,4}})));
  replaceable Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Subsystems.Borefield borFie(
    redeclare final package Medium=MediumBui,
    final datBorFie=datBorFie,
    final perPum=perPumBorFie,
    final TBorWatEntMax=TBorWatEntMax,
    final spePumBorMin=spePumBorMin,
    final dp_nominal=dpBorFie_nominal) if have_borFie
    "Borefield"
    annotation (Dialog(group="Borefield",enable=have_borFie),
    Placement(transformation(extent={{-80,-230},{-60,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerPPum(
    final k=0) if not have_borFie
    "Zero power"
    annotation (Placement(transformation(extent={{200,-90},{220,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerPHea(
    final k=0)
    "Zero power"
    annotation (Placement(transformation(extent={{200,50},{220,70}})));
equation
  connect(chi.port_bHeaWat,colHeaWat.ports_aCon[2])
    annotation (Line(points={{-10,0},{-108,0},{-108,-24}},color={0,127,255}));
  connect(chi.port_aHeaWat,colHeaWat.ports_bCon[2])
    annotation (Line(points={{-10,-12},{-132,-12},{-132,-24}},color={0,127,255}));
  connect(chi.port_bChiWat,colChiWat.ports_aCon[2])
    annotation (Line(points={{10,0},{108,0},{108,-24}},color={0,127,255}));
  connect(colChiWat.ports_bCon[2],chi.port_aChiWat)
    annotation (Line(points={{132,-24},{132,-12},{10,-12},{10,-12}},color={0,127,255}));
  connect(conSup.TChiWatSupSet,chi.TChiWatSupSet)
    annotation (Line(points={{-238,17},{-26,17},{-26,-8},{-12,-8}},color={0,0,127}));
  connect(chi.PPum,totPPum.u[2])
    annotation (Line(points={{12,-8},{20,-8},{20,-58},{258,-58},{258,-60}},color={0,0,127}));
  connect(colAmbWat.ports_aCon[2],borFie.port_b)
    annotation (Line(points={{12,-116},{14,-116},{14,-220},{-60,-220}},color={0,127,255}));
  connect(colAmbWat.ports_bCon[2],borFie.port_a)
    annotation (Line(points={{-12,-116},{-14,-116},{-14,-140},{-100,-140},{-100,-220},{-80,-220}},color={0,127,255}));
  connect(conSup.yAmb[1],borFie.u)
    annotation (Line(points={{-238,25},{-200,25},{-200,-212},{-82,-212}},color={0,0,127}));
  connect(valIsoCon.y_actual,borFie.yValIso_actual[1])
    annotation (Line(points={{-55,-113},{-40,-113},{-40,-198},{-90,-198},{-90,-217},{-82,-217}},color={0,0,127}));
  connect(valIsoEva.y_actual,borFie.yValIso_actual[2])
    annotation (Line(points={{55,-113},{40,-113},{40,-200},{-88,-200},{-88,-215},{-82,-215}},color={0,0,127}));
  connect(borFie.PPum,totPPum.u[3])
    annotation (Line(points={{-58,-216},{240,-216},{240,-62},{258,-62},{258,-60}},color={0,0,127}));
  connect(zerPPum.y,totPPum.u[3])
    annotation (Line(points={{222,-80},{254,-80},{254,-62},{258,-62},{258,-60}},color={0,0,127}));
  connect(zerPHea.y,totPHea.u[1])
    annotation (Line(points={{222,60},{258,60}},color={0,0,127}));
  connect(chi.PChi,totPCoo.u[1])
    annotation (Line(points={{12,-4},{20,-4},{20,20},{258,20}},color={0,0,127}));
  connect(uHea,conSup.uHea)
    annotation (Line(points={{-320,100},{-290,100},{-290,31},{-262,31}},color={255,0,255}));
  connect(conSup.yHea,chi.uHea)
    annotation (Line(points={{-238,31},{-20,31},{-20,-2},{-12,-2}},color={255,0,255}));
  connect(conSup.yCoo,chi.uCoo)
    annotation (Line(points={{-238,29},{-22,29},{-22,-4},{-12,-4}},color={255,0,255}));
  connect(valIsoCon.y_actual,conSup.yValIsoCon_actual)
    annotation (Line(points={{-55,-113},{-40,-113},{-40,-60},{-266,-60},{-266,15},{-262,15}},color={0,0,127}));
  connect(valIsoEva.y_actual,conSup.yValIsoEva_actual)
    annotation (Line(points={{55,-113},{40,-113},{40,-64},{-270,-64},{-270,13},{-262,13}},color={0,0,127}));
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
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Subsystems.Chiller\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Subsystems.Chiller</a>
for the operating principles and modeling assumptions.
The condenser and evaporator loops are equipped with constant speed pumps.
</li>
<li>
The supervisory controller ensures the load balancing between the condenser side
and the evaporator side of the chiller by controlling in sequence an optional
geothermal borefield (priority system), the district heat exchanger (second
priority system), and ultimately the chiller, by resetting down the chilled
water supply temperature, see
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.Supervisory\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.Supervisory</a>
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
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.Reset\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.Reset</a>.
<br/>
</p>
<p>
<img alt=\"System schematics\"
src=\"modelica://Buildings/Resources/Images/Experimental/DHC/EnergyTransferStations/Combined/Generation5/ChillerBorefield.png\"/>
</p>
</html>"));
end ChillerBorefield;
