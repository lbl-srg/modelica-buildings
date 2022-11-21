within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed;
block Controller "Tower fan speed control"

  parameter Integer nChi=2 "Total number of chillers";
  parameter Integer nTowCel=4 "Total number of cooling tower cells";
  parameter Integer nConWatPum=2 "Total number of condenser water pumps";
  parameter Boolean closeCoupledPlant=true
    "Flag to indicate if the plant is close coupled";
  parameter Boolean have_WSE=true
    "Flag to indicate if the plant has waterside economizer";
  parameter Real desCap(
    final unit="W",
    final quantity="HeatFlowRate")=1e6 "Plant design capacity";
  parameter Real fanSpeMin=0.1 "Minimum tower fan speed";
  parameter Real fanSpeMax=1 "Maximum tower fan speed"
    annotation (Dialog(enable=have_WSE));
  parameter Real chiMinCap[nChi](
    each final unit="W",
    final quantity=fill("HeatFlowRate", nChi))={1e4,1e4}
    "Minimum cyclining load below which chiller will begin cycling"
    annotation (Dialog(tab="WSE Enabled", group="Integrated", enable=have_WSE));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController intOpeCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(tab="WSE Enabled", group="Integrated", enable=have_WSE));
  parameter Real kIntOpe=1 "Gain of controller"
    annotation (Dialog(tab="WSE Enabled", group="Integrated",enable=have_WSE));
  parameter Real TiIntOpe(final quantity="Time", final unit="s")=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="WSE Enabled", group="Integrated",
                       enable=have_WSE and (intOpeCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                                            intOpeCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdIntOpe(final quantity="Time", final unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="WSE Enabled", group="Integrated",
                       enable=have_WSE and (intOpeCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                                            intOpeCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController chiWatCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(tab="WSE Enabled", group="WSE-only",enable=have_WSE));
  parameter Real kWSE=1 "Gain of controller"
    annotation (Dialog(tab="WSE Enabled", group="WSE-only",enable=have_WSE));
  parameter Real TiWSE(final quantity="Time", final unit="s")=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="WSE Enabled", group="WSE-only",
                       enable=have_WSE and (chiWatCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                                            chiWatCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdWSE(final quantity="Time", final unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="WSE Enabled", group="WSE-only",
                       enable=have_WSE and (chiWatCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                                            chiWatCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real LIFT_min[nChi](
    final unit=fill("K",nChi),
    final quantity=fill("TemperatureDifference",nChi),
    displayUnit=fill("degC",nChi))={12,12} "Minimum LIFT of each chiller"
      annotation (Dialog(tab="Return temperature control", group="Setpoint"));
  parameter Real TConWatSup_nominal[nChi](
    final unit=fill("K",nChi),
    final quantity=fill("ThermodynamicTemperature",nChi),
    displayUnit=fill("degC",nChi))={293.15,293.15}
    "Design condenser water supply temperature (condenser entering) of each chiller"
    annotation (Dialog(tab="Return temperature control", group="Setpoint"));
  parameter Real TConWatRet_nominal[nChi](
    final unit=fill("K",nChi),
    final quantity=fill("ThermodynamicTemperature",nChi),
    displayUnit=fill("degC",nChi))={303.15,303.15}
    "Design condenser water return temperature (condenser leaving) of each chiller"
    annotation (Dialog(tab="Return temperature control", group="Setpoint"));
  parameter Real TChiWatSupMin[nChi](
    final unit=fill("K",nChi),
    final quantity=fill("ThermodynamicTemperature",nChi),
    displayUnit=fill("degC",nChi))={278.15,278.15}
    "Lowest chilled water supply temperature of each chiller"
    annotation (Dialog(tab="Return temperature control", group="Setpoint"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController couPlaCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
    annotation (Dialog(tab="Return temperature control", group="Coupled plant",
                       enable=closeCoupledPlant));
  parameter Real kCouPla=1 "Gain of controller"
    annotation (Dialog(tab="Return temperature control", group="Coupled plant",
                       enable=closeCoupledPlant));
  parameter Real TiCouPla(final quantity="Time", final unit="s")=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Return temperature control", group="Coupled plant",
                       enable=closeCoupledPlant and (couPlaCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                                                     couPlaCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdCouPla(final quantity="Time", final unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Return temperature control", group="Coupled plant",
                       enable=closeCoupledPlant and (couPlaCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                                                     couPlaCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real yCouPlaMax=1 "Upper limit of output"
    annotation (Dialog(tab="Return temperature control", group="Coupled plant",
                       enable=closeCoupledPlant));
  parameter Real yCouPlaMin=0 "Lower limit of output"
    annotation (Dialog(tab="Return temperature control", group="Coupled plant",
                       enable=closeCoupledPlant));
  parameter Real samplePeriod=30
    "Period of sampling condenser water supply and return temperature difference"
    annotation (Dialog(tab="Return temperature control", group="Less coupled plant",
                       enable=not closeCoupledPlant));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController supWatCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
    annotation (Dialog(tab="Return temperature control", group="Less coupled plant",
                       enable=not closeCoupledPlant));
  parameter Real kSupCon=1 "Gain of controller"
    annotation (Dialog(tab="Return temperature control", group="Less coupled plant",
                       enable=not closeCoupledPlant));
  parameter Real TiSupCon(final quantity="Time", final unit="s")=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Return temperature control", group="Less coupled plant",
                       enable=not closeCoupledPlant and (supWatCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                                                         supWatCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdSupCon(final quantity="Time", final unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Return temperature control", group="Less coupled plant",
                       enable=not closeCoupledPlant and (supWatCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                                                         supWatCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real ySupConMax=1 "Upper limit of output"
    annotation (Dialog(tab="Return temperature control",
                       group="Less coupled plant", enable=not closeCoupledPlant));
  parameter Real ySupConMin=0 "Lower limit of output"
    annotation (Dialog(tab="Return temperature control",
                       group="Less coupled plant", enable=not closeCoupledPlant));
  parameter Real speChe=0.005 "Lower threshold value to check fan or pump speed"
    annotation (Dialog(tab="Advanced"));
  parameter Real cheMinFanSpe(final quantity="Time", final unit="s")=300
    "Threshold time for checking duration when tower fan equals to the minimum tower fan speed"
    annotation (Dialog(tab="Advanced", group="Return temperature control: Enable tower"));
  parameter Real cheMaxTowSpe(final quantity="Time", final unit="s")=300
    "Threshold time for checking duration when any enabled chiller maximum cooling speed equals to the minimum tower fan speed"
    annotation (Dialog(tab="Advanced", group="Return temperature control: Enable tower"));
  parameter Real cheTowOff(final quantity="Time", final unit="s")=60
    "Threshold time for checking duration when there is no enabled tower fan"
    annotation (Dialog(tab="Advanced", group="Return temperature control: Enable tower"));
  parameter Real iniPlaTim(final quantity="Time", final unit="s")=600
    "Time to hold return temperature to initial setpoint after plant being enabled"
    annotation (Dialog(tab="Advanced", group="Return temperature control: Setpoint"));
  parameter Real ramTim(final quantity="Time", final unit="s")=180
    "Time to ramp return water temperature from initial value to setpoint"
    annotation (Dialog(tab="Advanced", group="Return temperature control: Setpoint"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput chiLoa[nChi](final unit=fill(
        "W", nChi), final quantity=fill("HeatFlowRate", nChi))
                                               if have_WSE "Current load of each chiller"
    annotation (Placement(transformation(extent={{-140,120},{-100,160}}),
      iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller enabling status: true=ON"
    annotation (Placement(transformation(extent={{-140,100},{-100,140}}),
      iconTransformation(extent={{-140,140},{-100,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWse if have_WSE
    "Waterside economizer enabling status: true=ON"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
      iconTransformation(extent={{-140,110},{-100,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uFanSpe(
     final min=0,
     final max=1,
     final unit="1") "Measured tower fan speed"
     annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
       iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if have_WSE
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput reqPlaCap(
    final unit="W",
    final quantity="HeatFlowRate") "Current required plant capacity"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uMaxTowSpeSet[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi))
    "Maximum cooling tower speed setpoint from each chiller head pressure control loop"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTow[nTowCel]
    "Cooling tower cell operating status: true=running tower cell"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    "Plant enabling status"
    annotation (Placement(transformation(extent={{-140,-120},{-100,-80}}),
      iconTransformation(extent={{-140,-130},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatRet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Condenser water return temperature (condenser leaving)"
    annotation (Placement(transformation(extent={{-140,-140},{-100,-100}}),
      iconTransformation(extent={{-140,-160},{-100,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpe[nConWatPum](
    final min=fill(0, nConWatPum),
    final max=fill(1, nConWatPum),
    final unit=fill("1", nConWatPum)) "Current condenser water pump speed"
    annotation (Placement(transformation(extent={{-140,-160},{-100,-120}}),
      iconTransformation(extent={{-140,-190},{-100,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if not closeCoupledPlant
    "Condenser water supply temperature (condenser entering)"
    annotation (Placement(transformation(extent={{-140,-180},{-100,-140}}),
      iconTransformation(extent={{-140,-210},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySpeSet(
    final min=0,
    final max=1,
    final unit="1") "Fan speed setpoint of each cooling tower cell"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Controller
    fanSpeRetTem(
    final nChi=nChi,
    final nTowCel=nTowCel,
    final nConWatPum=nConWatPum,
    final have_WSE=have_WSE,
    final closeCoupledPlant=closeCoupledPlant,
    final desCap=desCap,
    final fanSpeMin=fanSpeMin,
    final LIFT_min=LIFT_min,
    final TConWatRet_nominal=TConWatRet_nominal,
    final TConWatSup_nominal=TConWatSup_nominal,
    final TChiWatSupMin=TChiWatSupMin,
    final cheMinFanSpe=cheMinFanSpe,
    final cheMaxTowSpe=cheMaxTowSpe,
    final cheTowOff=cheTowOff,
    final iniPlaTim=iniPlaTim,
    final ramTim=ramTim,
    final couPlaCon=couPlaCon,
    final kCouPla=kCouPla,
    final TiCouPla=TiCouPla,
    final yCouPlaMax=yCouPlaMax,
    final yCouPlaMin=yCouPlaMin,
    final TdCouPla=TdCouPla,
    final supWatCon=supWatCon,
    final kSupCon=kSupCon,
    final TiSupCon=TiSupCon,
    final TdSupCon=TdSupCon,
    final ySupConMax=ySupConMax,
    final ySupConMin=ySupConMin,
    final speChe=speChe)
    "Fan speed control based on condenser water return temperature control"
    annotation (Placement(transformation(extent={{20,-60},{60,-20}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.EnabledWSE.Controller
    fanSpeWse(
    final nChi=nChi,
    final chiMinCap=chiMinCap,
    final fanSpeMin=fanSpeMin,
    final intOpeCon=intOpeCon,
    final kIntOpe=kIntOpe,
    final TiIntOpe=TiIntOpe,
    final TdIntOpe=TdIntOpe,
    final fanSpeMax=fanSpeMax,
    final fanSpeChe=speChe,
    final chiWatCon=chiWatCon,
    final kWSE=kWSE,
    final TiWSE=TiWSE,
    final TdWSE=TdWSE) if have_WSE
    "Tower fan speed when waterside economizer is enabled"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

equation
  connect(fanSpeWse.ySpeSet, fanSpeRetTem.uTowSpeWSE)
    annotation (Line(points={{-18,50},{0,50},{0,-22},{18,-22}},  color={0,0,127}));
  connect(fanSpeWse.chiLoa, chiLoa)
    annotation (Line(points={{-42,59},{-60,59},{-60,140},{-120,140}},
      color={0,0,127}));
  connect(fanSpeWse.uChi, uChi)
    annotation (Line(points={{-42,56},{-64,56},{-64,120},{-120,120}},
      color={255,0,255}));
  connect(fanSpeWse.uWse, uWse) annotation (Line(points={{-42,52},{-68,52},{-68,
          100},{-120,100}}, color={255,0,255}));
  connect(fanSpeWse.uFanSpe,uFanSpe)
    annotation (Line(points={{-42,48},{-72,48},{-72,80},{-120,80}},
      color={0,0,127}));
  connect(fanSpeWse.TChiWatSup, TChiWatSup)
    annotation (Line(points={{-42,44},{-76,44},{-76,60},{-120,60}},
      color={0,0,127}));
  connect(fanSpeWse.TChiWatSupSet, TChiWatSupSet)
    annotation (Line(points={{-42,41},{-82,41},{-82,40},{-120,40}},
                                                  color={0,0,127}));
  connect(uChi, fanSpeRetTem.uChi)
    annotation (Line(points={{-120,120},{-64,120},{-64,-25},{18,-25}},
      color={255,0,255}));
  connect(uWse, fanSpeRetTem.uWse) annotation (Line(points={{-120,100},{-68,100},
          {-68,-28},{18,-28}}, color={255,0,255}));
  connect(fanSpeRetTem.reqPlaCap, reqPlaCap)
    annotation (Line(points={{18,-31},{-76,-31},{-76,0},{-120,0}},
      color={0,0,127}));
  connect(fanSpeRetTem.uMaxTowSpeSet, uMaxTowSpeSet)
    annotation (Line(points={{18,-34},{-80,-34},{-80,-20},{-120,-20}},
      color={0,0,127}));
  connect(uFanSpe,fanSpeRetTem.uFanSpe)
    annotation (Line(points={{-120,80},{-72,80},{-72,-37},{18,-37}},
      color={0,0,127}));
  connect(fanSpeRetTem.uTow, uTow) annotation (Line(points={{18,-40},{-68,-40},{
          -68,-60},{-120,-60}}, color={255,0,255}));
  connect(TChiWatSupSet, fanSpeRetTem.TChiWatSupSet)
    annotation (Line(points={{-120,40},{-60,40},{-60,-46},{18,-46}},
      color={0,0,127}));
  connect(fanSpeRetTem.uPla, uPla)
    annotation (Line(points={{18,-49},{-60,-49},{-60,-100},{-120,-100}},
      color={255,0,255}));
  connect(fanSpeRetTem.TConWatRet, TConWatRet)
    annotation (Line(points={{18,-52},{-56,-52},{-56,-120},{-120,-120}},
      color={0,0,127}));
  connect(fanSpeRetTem.uConWatPumSpe, uConWatPumSpe)
    annotation (Line(points={{18,-55},{-52,-55},{-52,-140},{-120,-140}},
      color={0,0,127}));
  connect(fanSpeRetTem.TConWatSup, TConWatSup)
    annotation (Line(points={{18,-58},{-48,-58},{-48,-160},{-120,-160}},
      color={0,0,127}));
  connect(fanSpeRetTem.ySpeSet,ySpeSet)
    annotation (Line(points={{62,-40},{80,-40},{80,0},{120,0}},
      color={0,0,127}));

annotation (
  defaultComponentName="towFanSpe",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-200},{100,200}}),
        graphics={
        Rectangle(
        extent={{-100,-200},{100,200}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,248},{100,210}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-100,170},{-64,154}},
          textColor={255,0,255},
          textString="uChi"),
        Text(
          extent={{-100,200},{-50,182}},
          textColor={0,0,127},
          textString="chiLoa",
          visible=have_WSE),
        Text(
          extent={{-98,110},{-48,92}},
          textColor={0,0,127},
          textString="uFanSpe"),
        Text(
          extent={{-100,80},{-26,64}},
          textColor={0,0,127},
          textString="TChiWatSup",
          visible=have_WSE),
        Text(
          extent={{-98,52},{-14,34}},
          textColor={0,0,127},
          textString="TChiWatSupSet"),
        Text(
          extent={{-96,20},{-40,2}},
          textColor={0,0,127},
          textString="reqPlaCap"),
        Text(
          extent={{-100,-10},{-8,-24}},
          textColor={0,0,127},
          textString="uMaxTowSpeSet"),
        Text(
          extent={{-96,-130},{-28,-148}},
          textColor={0,0,127},
          textString="TConWatRet"),
        Text(
          extent={{-94,-158},{10,-176}},
          textColor={0,0,127},
          textString="uConWatPumSpe"),
        Text(
          extent={{-98,-180},{-16,-200}},
          textColor={0,0,127},
          textString="TConWatSup",
          visible=not closeCoupledPlant),
        Text(
          extent={{48,10},{98,-8}},
          textColor={0,0,127},
          textString="ySpeSet"),
        Text(
          extent={{-96,140},{-60,124}},
          textColor={255,0,255},
          textString="uWse",
          visible=have_WSE),
        Text(
          extent={{-100,-40},{-64,-56}},
          textColor={255,0,255},
          textString="uTow"),
        Text(
          extent={{-100,-100},{-64,-116}},
          textColor={255,0,255},
          textString="uPla")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-180},{100,160}})),
Documentation(info="<html>
<p>
Block that outputs cooling tower fan speed <code>ySpeSet</code>. This is implemented
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft on March 23, 2020), section 5.2.12.2, item
1, 2, and 4.
These sections specifies sequences to control tower fan speed in the mode
when waterside economizer (if the plant does have it) is enabled or disabled, for
maintaining condenser water return temperature at its setpoint. This control is
used for plants with dynamic load profiles, i.e. those for which PLR may change
by more than approximately 25% in any hour.
It includes two subsequences:
</p>
<ul>
<li>
Sequence of controlling tower fan speed when waterside economizer is enabled, see
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.EnabledWSE.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.EnabledWSE.Controller</a>
for a description.
</li>
<li>
Sequence of controlling tower fan speed to maintain condenser water return temperature
at its setpoint. This control would be disabled if the waterside economizer is
enabled. see
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Controller</a>
for a description.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
September 14, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
