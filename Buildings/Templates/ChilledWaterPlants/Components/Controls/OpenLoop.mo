within Buildings.Templates.ChilledWaterPlants.Components.Controls;
block OpenLoop "Open loop controller (output signals only)"
  extends
    Buildings.Templates.ChilledWaterPlants.Components.Interfaces.PartialController(
     final typ=Buildings.Templates.ChilledWaterPlants.Types.Controller.OpenLoop);

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWatSupSet(
    k=Buildings.Templates.Data.Defaults.TChiWatSup)
    "CHW supply temperature set point"
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yPumChiWatPri(
    k=1)
    if have_varPumChiWatPri and have_varComPumChiWatPri
    "Primary CHW pump speed signal"
    annotation (Placement(transformation(extent={{-130,-70},{-110,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yPumChiWatPriDed[nPumChiWatPri](
    each k=1)
    if have_varPumChiWatPri and not have_varComPumChiWatPri
    "Primary CHW pump speed signal - Dedicated"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yPumChiWatSec(
    k=1) if have_pumChiWatSec
    "Secondary CHW pump speed signal"
    annotation (Placement(transformation(extent={{-130,-130},{-110,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yPumConWat(
    k=1) if typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
    and have_varPumConWat and have_varComPumConWat
    "CW pump speed signal"
    annotation (Placement(transformation(extent={{-130,-190},{-110,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yPumConWatDed[nPumConWat](
    each k=1)
    if typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled
    and have_varPumConWat and not have_varComPumConWat
    "CW pump speed signal - Dedicated"
    annotation (Placement(transformation(extent={{-100,-210},{-80,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yValChiWatChiIso[nChi](
    each k=1) if typValChiWatChiIso == Buildings.Templates.Components.Types.Valve.TwoWayModulating
    "Chiller CHW isolation valve opening signal"
    annotation (Placement(transformation(extent={{-130,190},{-110,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yValConWatChiIso[nChi](
    each k=1) if typValConWatChiIso == Buildings.Templates.Components.Types.Valve.TwoWayModulating
    "Chiller CW isolation valve opening signal"
    annotation (Placement(transformation(extent={{-60,150},{-40,170}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValCooInlIso[nCoo](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000) if typValCooInlIso == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    "Cooler inlet isolation valve opening signal"
    annotation (Placement(transformation(extent={{-160,270},{-140,290}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yValCooInlIso[nCoo](
    each k=1) if typValCooInlIso== Buildings.Templates.Components.Types.Valve.TwoWayModulating
    "Cooler inlet isolation valve opening signal"
    annotation (Placement(transformation(extent={{-130,250},{-110,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yValCooOutIso[nCoo](
    each k=1) if typValCooOutIso== Buildings.Templates.Components.Types.Valve.TwoWayModulating
    "Cooler outlet isolation valve opening signal"
    annotation (Placement(transformation(extent={{-50,230},{-30,250}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yCoo(
    k=1) if typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled
    "Cooler fan speed signal"
    annotation (Placement(transformation(extent={{40,210},{60,230}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1Chi[nChi](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000) "Chiller Start/Stop signal"
    annotation (Placement(transformation(extent={{-160,130},{-140,150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1Coo[nCoo](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000) "Cooler Start/Stop signal"
    annotation (Placement(transformation(extent={{0,230},{20,250}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValCooOutIso[nCoo](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000) if typValCooOutIso == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    "Cooler outlet isolation valve opening signal"
    annotation (Placement(transformation(extent={{-80,250},{-60,270}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumChiWatSec[nPumChiWatSec](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000) "Secondary CHW pump Start/Stop signal"
    annotation (Placement(transformation(extent={{-160,-110},{-140,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValChiWatChiIso[nChi](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000)
    if typValChiWatChiIso == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    "Chiller CHW isolation valve opening signal"
    annotation (Placement(transformation(extent={{-160,210},{-140,230}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValConWatChiIso[nChi](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000)
    if typValConWatChiIso == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    "Chiller CW isolation valve opening signal"
    annotation (Placement(transformation(extent={{-90,170},{-70,190}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumChiWatPri[nChi](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000) "Primary CHW pump Start/Stop signal"
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumConWat[nChi](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000)
    if typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
    "CW pump Start/Stop signal"
    annotation (Placement(transformation(extent={{-160,-170},{-140,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yValChiWatMinByp(
    k=1)
    "CHW minimum flow bypass valve opening signal"
    annotation (Placement(transformation(extent={{-160,30},{-140,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValChiWatChiBypSer[nChi](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000)
    "Chiller CHW bypass valve opening signal - Series chillers"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValChiWatChiBypPar(
    table=[0,0; 1,0; 1,1; 2,1],
    timeScale=1000,
    period=2000)
    "Chiller CHW bypass valve opening signal - Parallel chillers"
    annotation (Placement(transformation(extent={{-160,70},{-140,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yValChiWatEcoByp(k=1)
    "WSE CHW bypass valve opening signal"
    annotation (Placement(transformation(extent={{-160,-230},{-140,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yPumChiWatEco(
    k=1)
    "WSE CHW HX pump speed signal"
    annotation (Placement(transformation(extent={{-130,-290},{-110,-270}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumChiWatEco(
    table=[0,0; 1,0; 1,1; 2,1],
    timeScale=1000,
    period=2000) "WSE CHW HX pump Start/Stop signal"
    annotation (Placement(transformation(extent={{-160,-270},{-140,-250}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValConWatEcoIso(
    table=[0,0; 1,0; 1,1; 2,1],
    timeScale=1000,
    period=2000) "WSE CW isolation valve opening signal"
    annotation (Placement(transformation(extent={{-120,-250},{-100,-230}})));
protected
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatPri
    "Primary CHW pumps control bus"
    annotation (Placement(transformation(extent={{120,-80},{160,-40}}),
                      iconTransformation(extent={{-316,184},{-276,224}})));
  Buildings.Templates.Components.Interfaces.Bus busPumConWat
    "CW pumps control bus" annotation (Placement(transformation(extent={{120,-180},
            {160,-140}}),iconTransformation(extent={{-316,184},{-276,224}})));
  Buildings.Templates.Components.Interfaces.Bus busValConWatChiIso[nChi]
    "Chiller CW isolation valve control bus"
    annotation (Placement(
    transformation(extent={{120,140},{160,180}}), iconTransformation(extent={
            {-422,198},{-382,238}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatChiIso[nChi]
    "Chiller CHW isolation valves control bus" annotation (Placement(
        transformation(extent={{120,160},{160,200}}),  iconTransformation(extent={
            {-422,198},{-382,238}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatSec
    "Secondary CHW pumps control bus"
    annotation (Placement(transformation(
          extent={{120,-120},{160,-80}}),  iconTransformation(extent={{-316,184},{-276,
            224}})));
  Buildings.Templates.Components.Interfaces.Bus busValCooInlIso[nCoo]
    "Cooler inlet isolation valve control bus" annotation (Placement(
        transformation(extent={{120,260},{160,300}}),  iconTransformation(
          extent={{-422,198},{-382,238}})));
  Buildings.Templates.Components.Interfaces.Bus busValCooOutIso[nCoo]
    "Cooler outlet isolation valve control bus" annotation (Placement(
        transformation(extent={{120,240},{160,280}}), iconTransformation(extent=
           {{-422,198},{-382,238}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatMinByp
    "CHW minimum flow bypass valve control bus" annotation (Placement(
        transformation(extent={{120,20},{160,60}}), iconTransformation(extent={{
            -422,198},{-382,238}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatChiBypPar
    if typArrChi==Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Parallel
    "Chiller CHW bypass valve control bus - Parallel chillers"
    annotation (
      Placement(transformation(extent={{120,60},{160,100}}),iconTransformation(
          extent={{-422,198},{-382,238}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatChiBypSer[nChi]
    if typArrChi==Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Series
    "Chiller CHW bypass valve control bus - Series chillers"
    annotation (
      Placement(transformation(extent={{120,40},{160,80}}),  iconTransformation(
          extent={{-422,198},{-382,238}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatEcoByp
    "WSE CHW bypass valve control bus" annotation (Placement(transformation(
          extent={{120,-240},{160,-200}}), iconTransformation(extent={{-422,198},
            {-382,238}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatEco
    "WSE CHW HX pump control bus" annotation (Placement(transformation(extent={{120,
            -300},{160,-260}}),     iconTransformation(extent={{-316,184},{-276,
            224}})));
  Buildings.Templates.Components.Interfaces.Bus busValConWatEcoIso
    "WSE CW isolation valve control bus" annotation (Placement(transformation(
          extent={{120,-260},{160,-220}}), iconTransformation(extent={{-422,198},
            {-382,238}})));
equation
  connect(yPumChiWatPri.y, busPumChiWatPri.y)
    annotation (Line(points={{-108,-60},{140,-60}},
                                                  color={0,0,127}));
  connect(busPumChiWatPri, bus.pumChiWatPri) annotation (Line(
      points={{140,-60},{160,-60},{160,0},{260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(yPumChiWatSec.y, busPumChiWatSec.y)
    annotation (Line(points={{-108,-120},{140,-120},{140,-100}},
                                                          color={0,0,127}));
  connect(busPumChiWatSec, bus.pumChiWatSec) annotation (Line(
      points={{140,-100},{180,-100},{180,0},{260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(yPumConWat.y, busPumConWat.y)
    annotation (Line(points={{-108,-180},{140,-180},{140,-160}},
                                                             color={0,0,127}));
  connect(busPumConWat, bus.pumConWat) annotation (Line(
      points={{140,-160},{200,-160},{200,0},{260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(yValChiWatChiIso.y, busValChiWatChiIso.y) annotation (Line(points={{-108,
          200},{-60,200},{-60,190},{132,190},{132,180},{140,180}},
                                           color={0,0,127}));
  connect(yValConWatChiIso.y, busValConWatChiIso.y) annotation (Line(points={{-38,160},
          {140,160}},                    color={0,0,127}));
  connect(yValCooInlIso.y, busValCooInlIso.y) annotation (Line(points={{-108,260},
          {-100,260},{-100,280},{140,280}},
                                          color={0,0,127}));
  connect(yValCooOutIso.y, busValCooOutIso.y) annotation (Line(points={{-28,240},
          {-20,240},{-20,260},{140,260}},
                                        color={0,0,127}));
  connect(busValConWatChiIso, bus.valConWatChiIso) annotation (Line(
      points={{140,160},{170,160},{170,0},{260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busValChiWatChiIso, bus.valChiWatChiIso) annotation (Line(
      points={{140,180},{180,180},{180,0},{260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busValCooOutIso, bus.valCooOutIso) annotation (Line(
      points={{140,260},{194,260},{194,0},{260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busValCooInlIso, bus.valCooInlIso) annotation (Line(
      points={{140,280},{200,280},{200,0},{260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(y1ValCooInlIso.y[1], busValCooInlIso.y1)
    annotation (Line(points={{-138,280},{140,280}}, color={255,0,255}));
  connect(y1PumChiWatSec.y[1], busPumChiWatSec.y1)
    annotation (Line(points={{-138,-100},{140,-100}},
                                                    color={255,0,255}));
  connect(y1ValCooOutIso.y[1], busValCooOutIso.y1)
    annotation (Line(points={{-58,260},{140,260}}, color={255,0,255}));
  connect(y1ValChiWatChiIso.y[1], busValChiWatChiIso.y1) annotation (Line(
        points={{-138,220},{-40,220},{-40,200},{140,200},{140,180}},color={255,0,
          255}));
  connect(y1ValConWatChiIso.y[1], busValConWatChiIso.y1) annotation (Line(
        points={{-68,180},{100,180},{100,164},{140,164},{140,160}},
                                                               color={255,0,255}));
  connect(y1PumChiWatPri.y[1], busPumChiWatPri.y1) annotation (Line(points={{-138,
          -40},{140,-40},{140,-60}}, color={255,0,255}));
  connect(y1PumConWat.y[1], busPumConWat.y1) annotation (Line(points={{-138,-160},
          {140,-160}},                   color={255,0,255}));
  connect(yValChiWatMinByp.y, busValChiWatMinByp.y)
    annotation (Line(points={{-138,40},{140,40}},   color={0,0,127}));
  connect(y1ValChiWatChiBypSer.y[1], busValChiWatChiBypSer.y1)
    annotation (Line(points={{-98,60},{140,60}},color={255,0,255}));
  connect(busValChiWatChiBypSer, bus.valChiWatChiByp) annotation (Line(
      points={{140,60},{200,60},{200,0},{260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busValChiWatChiBypPar, bus.valChiWatChiByp) annotation (Line(
      points={{140,80},{188,80},{188,0},{260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(y1ValChiWatChiBypPar.y[1], busValChiWatChiBypPar.y1)
    annotation (Line(points={{-138,80},{140,80}}, color={255,0,255}));
  connect(busValChiWatMinByp, bus.valChiWatMinByp) annotation (Line(
      points={{140,40},{202,40},{202,0},{260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(yPumChiWatEco.y, busPumChiWatEco.y) annotation (Line(points={{-108,-280},
          {140,-280}},            color={0,0,127}));
  connect(y1PumChiWatEco.y[1], busPumChiWatEco.y1)
    annotation (Line(points={{-138,-260},{140,-260},{140,-280}},
                                                      color={255,0,255}));
  connect(yValChiWatEcoByp.y, busValChiWatEcoByp.y)
    annotation (Line(points={{-138,-220},{140,-220}}, color={0,0,127}));
  connect(busPumChiWatEco, bus.pumChiWatEco) annotation (Line(
      points={{140,-280},{240,-280},{240,0},{260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busValChiWatEcoByp, bus.valChiWatEcoByp) annotation (Line(
      points={{140,-220},{232,-220},{232,0},{260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busValConWatEcoIso, bus.valConWatEcoIso) annotation (Line(
      points={{140,-240},{236,-240},{236,0},{260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(y1ValConWatEcoIso.y[1], busValConWatEcoIso.y1) annotation (Line(
        points={{-98,-240},{24,-240},{24,-240},{140,-240}}, color={255,0,255}));
  connect(yPumConWatDed.y, busPumConWat.y) annotation (Line(points={{-78,-200},
          {140,-200},{140,-160}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(yPumChiWatPriDed.y, busPumChiWatPri.y) annotation (Line(points={{-78,
          -80},{140,-80},{140,-60}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(y1Chi.y[1], bus.y1Chi) annotation (Line(points={{-138,140},{248,140},
          {248,0},{260,0}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TChiWatSupSet.y, bus.TChiWatSupSet) annotation (Line(points={{-78,120},
          {244,120},{244,0},{260,0}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(y1Coo.y[1], bus.y1Coo) annotation (Line(points={{22,240},{252,240},{
          252,0},{260,0}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(yCoo.y, bus.yCoo) annotation (Line(points={{62,220},{256,220},{256,0},
          {260,0}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (
  defaultComponentName="ctr",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OpenLoop;
