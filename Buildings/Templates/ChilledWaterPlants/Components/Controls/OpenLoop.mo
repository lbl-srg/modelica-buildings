within Buildings.Templates.ChilledWaterPlants.Components.Controls;
block OpenLoop "Open loop controller (output signals only)"
  extends
    Buildings.Templates.ChilledWaterPlants.Components.Interfaces.PartialController(
     final typ=Buildings.Templates.ChilledWaterPlants.Types.Controller.OpenLoop);

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWatSupSet[nChi](
    each k=Buildings.Templates.Data.Defaults.TChiWatSup)
    "CHW supply temperature set point"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yPumChiWatPri(
    k=1)
    if typCtrSpePumChiWatPri == Buildings.Templates.Components.Types.PumpMultipleSpeedControl.VariableCommon
    "Primary CHW pump speed signal"
    annotation (Placement(transformation(extent={{-130,-110},{-110,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yPumChiWatSec(
    k=1)
    if have_pumChiWatSec and
    typCtrSpePumChiWatSec==Buildings.Templates.Components.Types.PumpMultipleSpeedControl.VariableCommon
    "Secondary CHW pump speed signal"
    annotation (Placement(transformation(extent={{-130,-170},{-110,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yPumConWat(
    k=1) if typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
     and typCtrSpePumConWat==Buildings.Templates.Components.Types.PumpMultipleSpeedControl.VariableCommon
    "CW pump speed signal"
    annotation (Placement(transformation(extent={{-130,-230},{-110,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yPumConWatDed[nChi](
    each k=1)
    if typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled and
    typCtrSpePumConWat==Buildings.Templates.Components.Types.PumpMultipleSpeedControl.VariableDedicated
    "CW pump speed signal - Dedicated"
    annotation (Placement(transformation(extent={{-100,-250},{-80,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yValChiWatChiIso[nChi](
    each k=1) if typValChiWatChiIso == Buildings.Templates.Components.Types.Valve.TwoWayModulating
    "Chiller CHW isolation valve opening signal"
    annotation (Placement(transformation(extent={{-130,150},{-110,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yValConWatChiIso[nChi](
    each k=1) if typValConWatChiIso == Buildings.Templates.Components.Types.Valve.TwoWayModulating
    "Chiller CW isolation valve opening signal"
    annotation (Placement(transformation(extent={{-60,110},{-40,130}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValCooInlIso[nCoo](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000) if typValCooInlIso == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    "Cooler inlet isolation valve opening signal"
    annotation (Placement(transformation(extent={{-160,230},{-140,250}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yValCooInlIso[nCoo](
    each k=1) if typValCooInlIso== Buildings.Templates.Components.Types.Valve.TwoWayModulating
    "Cooler inlet isolation valve opening signal"
    annotation (Placement(transformation(extent={{-130,210},{-110,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yValCooOutIso[nCoo](
    each k=1) if typValCooOutIso== Buildings.Templates.Components.Types.Valve.TwoWayModulating
    "Cooler outlet isolation valve opening signal"
    annotation (Placement(transformation(extent={{-50,190},{-30,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yCoo[nCoo](each k=1)
    if typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled
    "Cooler fan speed signal"
    annotation (Placement(transformation(extent={{40,174},{60,194}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1Chi[nChi](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000) "Chiller Start/Stop signal"
    annotation (Placement(transformation(extent={{-160,90},{-140,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1Coo[nCoo](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000) "Cooler Start/Stop signal"
    annotation (Placement(transformation(extent={{0,190},{20,210}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValCooOutIso[nCoo](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000) if typValCooOutIso == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    "Cooler outlet isolation valve opening signal"
    annotation (Placement(transformation(extent={{-80,210},{-60,230}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumChiWatSec[nPumChiWatSec](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000)
    "Secondary CHW pump Start/Stop signal"
    annotation (Placement(transformation(extent={{-160,-150},{-140,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValChiWatChiIso[nChi](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000) if typValChiWatChiIso == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    "Chiller CHW isolation valve opening signal"
    annotation (Placement(transformation(extent={{-160,170},{-140,190}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValConWatChiIso[nChi](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000) if typValConWatChiIso == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    "Chiller CW isolation valve opening signal"
    annotation (Placement(transformation(extent={{-90,130},{-70,150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumChiWatPri[nChi](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000) "Primary CHW pump Start/Stop signal"
    annotation (Placement(transformation(extent={{-160,-90},{-140,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumConWat[nChi](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000)
    if typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
    "CW pump Start/Stop signal"
    annotation (Placement(transformation(extent={{-160,-210},{-140,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yValChiWatMinByp(
    k=1)
    "CHW minimum flow bypass valve opening signal"
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValChiWatChiBypSer[nChi](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000)
    "Chiller CHW bypass valve opening signal - Series chillers"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValChiWatChiBypPar(
    table=[0,0; 1,0; 1,1; 2,1],
    timeScale=1000,
    period=2000)
    "Chiller CHW bypass valve opening signal - Parallel chillers"
    annotation (Placement(transformation(extent={{-160,30},{-140,50}})));
protected
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatPri
    "Primary CHW pumps control bus"
    annotation (Placement(transformation(extent={{120,-120},{160,-80}}),
                      iconTransformation(extent={{-316,184},{-276,224}})));
  Buildings.Templates.Components.Interfaces.Bus busPumConWat
    "CW pumps control bus" annotation (Placement(transformation(extent={{120,-220},
            {160,-180}}),iconTransformation(extent={{-316,184},{-276,224}})));
  Buildings.Templates.Components.Interfaces.Bus busChi[nChi]
    "Chiller control bus" annotation (Placement(transformation(extent={{120,80},
            {160,120}}), iconTransformation(extent={{-422,198},{-382,238}})));
  Buildings.Templates.Components.Interfaces.Bus busValConWatChiIso[nChi]
    "Chiller CW isolation valve control bus"
    annotation (Placement(
    transformation(extent={{120,100},{160,140}}), iconTransformation(extent={
            {-422,198},{-382,238}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatChiIso[nChi]
    "Chiller CHW isolation valves control bus" annotation (Placement(
        transformation(extent={{120,120},{160,160}}),  iconTransformation(extent={
            {-422,198},{-382,238}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatSec
    "Secondary CHW pumps control bus"
    annotation (Placement(transformation(
          extent={{120,-160},{160,-120}}), iconTransformation(extent={{-316,184},{-276,
            224}})));
  Buildings.Templates.Components.Interfaces.Bus busCoo[nCoo]
    "Coolers control bus" annotation (Placement(transformation(extent={{120,180},
            {160,220}}), iconTransformation(extent={{-316,184},{-276,224}})));
  Buildings.Templates.Components.Interfaces.Bus busValCooInlIso[nCoo]
    "Cooler inlet isolation valve control bus" annotation (Placement(
        transformation(extent={{120,220},{160,260}}),  iconTransformation(
          extent={{-422,198},{-382,238}})));
  Buildings.Templates.Components.Interfaces.Bus busValCooOutIso[nCoo]
    "Cooler outlet isolation valve control bus" annotation (Placement(
        transformation(extent={{120,200},{160,240}}), iconTransformation(extent=
           {{-422,198},{-382,238}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatMinByp
    "CHW minimum flow bypass valve control bus" annotation (Placement(
        transformation(extent={{120,-60},{160,-20}}),
                                                    iconTransformation(extent={{
            -422,198},{-382,238}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatChiBypPar
    if typArrChi==Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Parallel
    "Chiller CHW bypass valve control bus - Parallel chillers"
    annotation (
      Placement(transformation(extent={{120,20},{160,60}}), iconTransformation(
          extent={{-422,198},{-382,238}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatChiBypSer[nChi]
    if typArrChi==Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Series
    "Chiller CHW bypass valve control bus - Series chillers"
    annotation (
      Placement(transformation(extent={{120,-20},{160,20}}), iconTransformation(
          extent={{-422,198},{-382,238}})));
equation
  connect(yPumChiWatPri.y, busPumChiWatPri.y)
    annotation (Line(points={{-108,-100},{140,-100}},
                                                  color={0,0,127}));
  connect(busPumChiWatPri, bus.pumChiWatPri) annotation (Line(
      points={{140,-100},{160,-100},{160,0},{220,0}},
      color={255,204,51},
      thickness=0.5));
  connect(yPumChiWatSec.y, busPumChiWatSec.y)
    annotation (Line(points={{-108,-160},{140,-160},{140,-140}},
                                                          color={0,0,127}));
  connect(busPumChiWatSec, bus.pumChiWatSec) annotation (Line(
      points={{140,-140},{180,-140},{180,0},{220,0}},
      color={255,204,51},
      thickness=0.5));
  connect(yPumConWat.y, busPumConWat.y)
    annotation (Line(points={{-108,-220},{140,-220},{140,-200}},
                                                             color={0,0,127}));
  connect(busPumConWat, bus.pumConWat) annotation (Line(
      points={{140,-200},{200,-200},{200,0},{220,0}},
      color={255,204,51},
      thickness=0.5));
  connect(TChiWatSupSet.y, busChi.TChiWatSupSet)
    annotation (Line(points={{-78,80},{140,80},{140,100}},
                                                      color={0,0,127}));
  connect(yPumConWatDed.y, busPumConWat.y)
    annotation (Line(points={{-78,-240},{140,-240},{140,-200}},
                                                            color={0,0,127}));
  connect(yValChiWatChiIso.y, busValChiWatChiIso.y) annotation (Line(points={{-108,
          160},{-60,160},{-60,150},{132,150},{132,140},{140,140}},
                                           color={0,0,127}));
  connect(yValConWatChiIso.y, busValConWatChiIso.y) annotation (Line(points={{-38,120},
          {140,120}},                    color={0,0,127}));
  connect(yValCooInlIso.y, busValCooInlIso.y) annotation (Line(points={{-108,220},
          {-100,220},{-100,240},{140,240}},
                                          color={0,0,127}));
  connect(yValCooOutIso.y, busValCooOutIso.y) annotation (Line(points={{-28,200},
          {-20,200},{-20,220},{140,220}},
                                        color={0,0,127}));
  connect(busChi, bus.chi) annotation (Line(
      points={{140,100},{160,100},{160,0},{220,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busValConWatChiIso, bus.valConWatChiIso) annotation (Line(
      points={{140,120},{170,120},{170,0},{220,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busValChiWatChiIso, bus.valChiWatChiIso) annotation (Line(
      points={{140,140},{180,140},{180,0},{220,0}},
      color={255,204,51},
      thickness=0.5));
  connect(yCoo.y, busCoo.y)
    annotation (Line(points={{62,184},{82,184},{82,200},{140,200}},
                                                            color={0,0,127}));
  connect(busCoo, bus.coo) annotation (Line(
      points={{140,200},{194,200},{194,0},{220,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busValCooOutIso, bus.valCooOutIso) annotation (Line(
      points={{140,220},{194,220},{194,0},{220,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busValCooInlIso, bus.valCooInlIso) annotation (Line(
      points={{140,240},{200,240},{200,0},{220,0}},
      color={255,204,51},
      thickness=0.5));
  connect(y1Chi.y[1], busChi.y1) annotation (Line(points={{-138,100},{140,100}},
                         color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(y1Coo.y[1], busCoo.y1)
    annotation (Line(points={{22,200},{140,200}}, color={255,0,255}));
  connect(y1ValCooInlIso.y[1], busValCooInlIso.y1)
    annotation (Line(points={{-138,240},{140,240}}, color={255,0,255}));
  connect(y1PumChiWatSec.y[1], busPumChiWatSec.y1)
    annotation (Line(points={{-138,-140},{140,-140}},
                                                    color={255,0,255}));
  connect(y1ValCooOutIso.y[1], busValCooOutIso.y1)
    annotation (Line(points={{-58,220},{140,220}}, color={255,0,255}));
  connect(y1ValChiWatChiIso.y[1], busValChiWatChiIso.y1) annotation (Line(
        points={{-138,180},{-40,180},{-40,160},{140,160},{140,140}},color={255,0,
          255}));
  connect(y1ValConWatChiIso.y[1], busValConWatChiIso.y1) annotation (Line(
        points={{-68,140},{100,140},{100,124},{140,124},{140,120}},
                                                               color={255,0,255}));
  connect(y1PumChiWatPri.y[1], busPumChiWatPri.y1) annotation (Line(points={{-138,
          -80},{140,-80},{140,-100}},color={255,0,255}));
  connect(y1PumConWat.y[1], busPumConWat.y1) annotation (Line(points={{-138,-200},
          {140,-200}},                   color={255,0,255}));
  connect(busValChiWatMinByp, bus.valChiWatMinByp) annotation (Line(
      points={{140,-40},{170,-40},{170,0},{220,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(yValChiWatMinByp.y, busValChiWatMinByp.y)
    annotation (Line(points={{-138,-40},{140,-40}}, color={0,0,127}));
  connect(y1ValChiWatChiBypSer.y[1], busValChiWatChiBypSer.y1)
    annotation (Line(points={{-138,0},{140,0}}, color={255,0,255}));
  connect(busValChiWatChiBypSer, bus.valChiWatChiByp) annotation (Line(
      points={{140,0},{220,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busValChiWatChiBypPar, bus.valChiWatChiByp) annotation (Line(
      points={{140,40},{188,40},{188,0},{220,0}},
      color={255,204,51},
      thickness=0.5));
  connect(y1ValChiWatChiBypPar.y[1], busValChiWatChiBypPar.y1)
    annotation (Line(points={{-138,40},{140,40}}, color={255,0,255}));
  annotation (
  defaultComponentName="ctr",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OpenLoop;
