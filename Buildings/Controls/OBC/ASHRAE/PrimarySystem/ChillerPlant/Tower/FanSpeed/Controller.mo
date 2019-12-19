within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed;
block Controller "Tower fan speed control"

  parameter Integer nChi=2 "Total number of chillers";
  parameter Integer nTowCel=4 "Total number of cooling tower cells";
  parameter Integer nConWatPum=2 "Total number of condenser water pumps";
  parameter Boolean closeCoupledPlant=true
    "Flag to indicate if the plant is close coupled";
  parameter Boolean hasWSE=true
    "Flag to indicate if the plant has waterside economizer";
  parameter Modelica.SIunits.HeatFlowRate desCap=1e6 "Plant design capacity";
  parameter Real fanSpeMin=0.1 "Minimum tower fan speed";
  parameter Real fanSpeMax=1 "Maximum tower fan speed"
    annotation (Dialog(enable=hasWSE));
  parameter Modelica.SIunits.HeatFlowRate chiMinCap[nChi]={1e4,1e4}
    "Minimum cyclining load below which chiller will begin cycling"
    annotation (Dialog(tab="WSE Enabled", group="Integrated", enable=hasWSE));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController intOpeCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(tab="WSE Enabled", group="Integrated", enable=hasWSE));
  parameter Real kIntOpe=1 "Gain of controller"
    annotation (Dialog(tab="WSE Enabled", group="Integrated",enable=hasWSE));
  parameter Modelica.SIunits.Time TiIntOpe=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="WSE Enabled", group="Integrated",
                       enable=hasWSE and (intOpeCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                                          intOpeCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Modelica.SIunits.Time TdIntOpe=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="WSE Enabled", group="Integrated",
                       enable=hasWSE and (intOpeCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                                          intOpeCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController chiWatCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(tab="WSE Enabled", group="WSE-only",enable=hasWSE));
  parameter Real kWSE=1 "Gain of controller"
    annotation (Dialog(tab="WSE Enabled", group="WSE-only",enable=hasWSE));
  parameter Modelica.SIunits.Time TiWSE=0.5 "Time constant of integrator block"
    annotation (Dialog(tab="WSE Enabled", group="WSE-only",
                       enable=hasWSE and (chiWatCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                                          chiWatCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Modelica.SIunits.Time TdWSE=0.1 "Time constant of derivative block"
    annotation (Dialog(tab="WSE Enabled", group="WSE-only",
                       enable=hasWSE and (chiWatCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                                          chiWatCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

  parameter Modelica.SIunits.TemperatureDifference LIFT_min[nChi]={12,12} "Minimum LIFT of each chiller"
    annotation (Dialog(tab="Return temperature control", group="Setpoint"));
  parameter Modelica.SIunits.Temperature TConWatRet_nominal[nChi]={303.15,303.15}
    "Condenser water return temperature (condenser leaving) of each chiller"
    annotation (Dialog(tab="Return temperature control", group="Setpoint"));
  parameter Modelica.SIunits.Temperature TChiWatSupMin[nChi]={278.15,278.15}
    "Lowest chilled water supply temperature of each chiller"
    annotation (Dialog(tab="Return temperature control", group="Setpoint"));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController couPlaCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
    annotation (Dialog(tab="Return temperature control", group="Coupled plant",
                       enable=closeCoupledPlant));
  parameter Real kCouPla=1 "Gain of controller"
    annotation (Dialog(tab="Return temperature control", group="Coupled plant",
                       enable=closeCoupledPlant));
  parameter Modelica.SIunits.Time TiCouPla=0.5 "Time constant of integrator block"
    annotation (Dialog(tab="Return temperature control", group="Coupled plant",
                       enable=closeCoupledPlant and (couPlaCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                                                     couPlaCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Modelica.SIunits.Time TdCouPla=0.1 "Time constant of derivative block"
    annotation (Dialog(tab="Return temperature control", group="Coupled plant",
                       enable=closeCoupledPlant and (couPlaCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                                                     couPlaCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real yCouPlaMax=1 "Upper limit of output"
    annotation (Dialog(tab="Return temperature control", group="Coupled plant",
                       enable=closeCoupledPlant));
  parameter Real yCouPlaMin=0 "Lower limit of output"
    annotation (Dialog(tab="Return temperature control", group="Coupled plant",
                       enable=closeCoupledPlant));
  parameter Modelica.SIunits.TemperatureDifference desTemDif=8
    "Design condenser water temperature difference"
    annotation (Dialog(tab="Return temperature control",
                       group="Less coupled plant", enable=not closeCoupledPlant));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController retWatCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
    annotation (Dialog(tab="Return temperature control", group="Less coupled plant",
                       enable=not closeCoupledPlant));
  parameter Real kRetCon=1 "Gain of controller"
    annotation (Dialog(tab="Return temperature control", group="Less coupled plant",
                       enable=not closeCoupledPlant));
  parameter Modelica.SIunits.Time TiRetCon=0.5 "Time constant of integrator block"
    annotation (Dialog(tab="Return temperature control", group="Less coupled plant",
                       enable=not closeCoupledPlant and (retWatCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                                                         retWatCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Modelica.SIunits.Time TdRetCon=0.1 "Time constant of derivative block"
    annotation (Dialog(tab="Return temperature control", group="Less coupled plant",
                       enable=not closeCoupledPlant and (retWatCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                                                         retWatCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real yRetConMax=1 "Upper limit of output"
    annotation (Dialog(tab="Return temperature control", group="Less coupled plant",
                       enable=not closeCoupledPlant));
  parameter Real yRetConMin=0 "Lower limit of output"
    annotation (Dialog(tab="Return temperature control", group="Less coupled plant",
                       enable=not closeCoupledPlant));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController supWatCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
    annotation (Dialog(tab="Return temperature control", group="Less coupled plant",
                       enable=not closeCoupledPlant));
  parameter Real kSupCon=1 "Gain of controller"
    annotation (Dialog(tab="Return temperature control", group="Less coupled plant",
                       enable=not closeCoupledPlant));
  parameter Modelica.SIunits.Time TiSupCon=0.5 "Time constant of integrator block"
    annotation (Dialog(tab="Return temperature control", group="Less coupled plant",
                       enable=not closeCoupledPlant and (supWatCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                                                         supWatCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Modelica.SIunits.Time TdSupCon=0.1 "Time constant of derivative block"
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
  parameter Real cheMinFanSpe=300
    "Threshold time for checking duration when tower fan equals to the minimum tower fan speed"
    annotation (Dialog(tab="Advanced", group="Return temperature control: Enable tower"));
  parameter Real cheMaxTowSpe=300
    "Threshold time for checking duration when any enabled chiller maximum cooling speed equals to the minimum tower fan speed"
    annotation (Dialog(tab="Advanced", group="Return temperature control: Enable tower"));
  parameter Real cheTowOff=60
    "Threshold time for checking duration when there is no enabled tower fan"
    annotation (Dialog(tab="Advanced", group="Return temperature control: Enable tower"));
  parameter Modelica.SIunits.Time iniPlaTim=600
    "Time to hold return temperature to initial setpoint after plant being enabled"
    annotation (Dialog(tab="Advanced", group="Return temperature control: Setpoint"));
  parameter Modelica.SIunits.Time ramTim=180
    "Time to ramp return water temperature from initial value to setpoint"
    annotation (Dialog(tab="Advanced", group="Return temperature control: Setpoint"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput chiLoa[nChi](
    final unit=fill("W", nChi),
    final quantity=fill("HeatFlowRate", nChi)) if hasWSE "Current load of each chiller"
    annotation (Placement(transformation(extent={{-140,120},{-100,160}}),
      iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller enabling status: true=ON"
    annotation (Placement(transformation(extent={{-140,100},{-100,140}}),
      iconTransformation(extent={{-140,140},{-100,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWseSta if hasWSE
    "Waterside economizer enabling status: true=ON"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
      iconTransformation(extent={{-140,110},{-100,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uFanSpe(
     final min=0,
     final max=1,
     final unit="1") "Tower fan speed"
     annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
       iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    final quantity="ThermodynamicTemperature") if hasWSE
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput reqPlaCap(
    final unit="W",
    final quantity="Power") "Current required plant capacity"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uMaxTowSpeSet[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi))
    "Maximum cooling tower speed setpoint from each chiller head pressure control loop"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTowSta[nTowCel]
    "Cooling tower cell operating status: true=running tower cell"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    "Plant enabling status"
    annotation (Placement(transformation(extent={{-140,-120},{-100,-80}}),
      iconTransformation(extent={{-140,-130},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatRet(
    final unit="K",
    final quantity="ThermodynamicTemperature") "Condenser water return temperature"
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
    final quantity="ThermodynamicTemperature") if not closeCoupledPlant
    "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-140,-180},{-100,-140}}),
      iconTransformation(extent={{-140,-210},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFanSpe(
    final min=0,
    final max=1,
    final unit="1") "Cooling tower fan speed"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.ReturnWaterTemperature.Controller
    fanSpeRetTem(
    final nChi=nChi,
    final nTowCel=nTowCel,
    final nConWatPum=nConWatPum,
    final hasWSE=hasWSE,
    final closeCoupledPlant=closeCoupledPlant,
    final desCap=desCap,
    final fanSpeMin=fanSpeMin,
    final LIFT_min=LIFT_min,
    final TConWatRet_nominal=TConWatRet_nominal,
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
    final desTemDif=desTemDif,
    final retWatCon=retWatCon,
    final kRetCon=kRetCon,
    final TiRetCon=TiRetCon,
    final TdRetCon=TdRetCon,
    final yRetConMax=yRetConMax,
    final yRetConMin=yRetConMin,
    final supWatCon=supWatCon,
    final kSupCon=kSupCon,
    final TiSupCon=TiSupCon,
    final TdSupCon=TdSupCon,
    final ySupConMax=ySupConMax,
    final ySupConMin=ySupConMin,
    final speChe=speChe)
    "Fan speed control based on condenser water return temperature control"
    annotation (Placement(transformation(extent={{20,-60},{60,-20}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.EnabledWSE.Controller
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
    final TdWSE=TdWSE) if hasWSE
    "Tower fan speed when waterside economizer is enabled"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

equation
  connect(fanSpeWse.yFanSpe, fanSpeRetTem.uTowSpeWSE)
    annotation (Line(points={{-18,50},{0,50},{0,-22},{18,-22}},  color={0,0,127}));
  connect(fanSpeWse.chiLoa, chiLoa)
    annotation (Line(points={{-42,60},{-60,60},{-60,140},{-120,140}},
      color={0,0,127}));
  connect(fanSpeWse.uChi, uChi)
    annotation (Line(points={{-42,56},{-64,56},{-64,120},{-120,120}},
      color={255,0,255}));
  connect(fanSpeWse.uWseSta, uWseSta)
    annotation (Line(points={{-42,52},{-68,52}, {-68,100},{-120,100}},
      color={255,0,255}));
  connect(fanSpeWse.uFanSpe,uFanSpe)
    annotation (Line(points={{-42,48},{-72,48},{-72,80},{-120,80}},
      color={0,0,127}));
  connect(fanSpeWse.TChiWatSup, TChiWatSup)
    annotation (Line(points={{-42,44},{-76,44},{-76,60},{-120,60}},
      color={0,0,127}));
  connect(fanSpeWse.TChiWatSupSet, TChiWatSupSet)
    annotation (Line(points={{-42,40},{-120,40}}, color={0,0,127}));
  connect(uChi, fanSpeRetTem.uChi)
    annotation (Line(points={{-120,120},{-64,120},{-64,-25},{18,-25}},
      color={255,0,255}));
  connect(uWseSta, fanSpeRetTem.uWseSta)
    annotation (Line(points={{-120,100},{-68,100},{-68,-28},{18,-28}},
      color={255,0,255}));
  connect(fanSpeRetTem.reqPlaCap, reqPlaCap)
    annotation (Line(points={{18,-31},{-76,-31},{-76,0},{-120,0}},
      color={0,0,127}));
  connect(fanSpeRetTem.uMaxTowSpeSet, uMaxTowSpeSet)
    annotation (Line(points={{18,-34},{-80,-34},{-80,-20},{-120,-20}},
      color={0,0,127}));
  connect(uFanSpe,fanSpeRetTem.uFanSpe)
    annotation (Line(points={{-120,80},{-72,80},{-72,-37},{18,-37}},
      color={0,0,127}));
  connect(fanSpeRetTem.uTowSta, uTowSta)
    annotation (Line(points={{18,-40},{-68,-40},{-68,-60},{-120,-60}},
      color={255,0,255}));
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
  connect(fanSpeRetTem.yFanSpe, yFanSpe)
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
          lineColor={0,0,255},
          textString="%name")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-180},{100,160}})),
Documentation(info="<html>
<p>
Block that outputs cooling tower fan speed <code>yFanSpe</code>. This is implemented 
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II – 
Central Plants and Hydronic Systems (Draft 6 on July 25, 2019), section 5.2.12.2, item
1, 2, and 4. 
These sections specifies sequences to control tower fan speed in the mode
when waterside economizer (if the plant does have it) is enabled or disabled, for
maintaining condenser water return temperature at its setpoint.
It includes two subsequences:
</p>
<ul>
<li>
Sequence of controlling tower fan speed when waterside economizer is enabled, see
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.EnabledWSE.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.EnabledWSE.Controller</a>
for a description.
</li>
<li>
Sequence of controlling tower fan speed to maintain condenser water return temperature
at its setpoint. This control would be disabled if the waterside economizer is
enabled. see
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.ReturnWaterTemperature.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.ReturnWaterTemperature.Controller</a>
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
