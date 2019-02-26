within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block Change "Calculates the chiller stage signal"

  parameter Integer nSta = 2
  "Number of stages";

  parameter Modelica.SIunits.Time delayStaCha = 15*60
  "Minimum chiller load time below or above current stage before a change is enabled";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y(
    final max=1,
    final min=-1)
    "fixme change to chiller stage and loop back as input to up and down seq"
    annotation (Placement(transformation(extent=
    {{180,-10},{200,10}}), iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt
    "Boolean to integer conversion"
    annotation (Placement(transformation(extent={{110,0},{130,20}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    "Boolean to integer conversion"
    annotation (Placement(transformation(extent={{110,-40},{130,-20}})));

  Buildings.Controls.OBC.CDL.Integers.Add addInt(
    final k2=-1)
    "Adder"
    annotation (Placement(transformation(extent={{150,-10},{170,10}})));

  Capacities              staCap
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));
  PartLoadRatios              PLRs
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Up              staUp
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Down              staDow
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  CapacityRequirement capReq
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  CDL.Interfaces.IntegerInput                        uSta(final min=0, final
      max=nSta)       "Chiller stage"
    annotation (Placement(transformation(extent={{-220,160},{-180,200}}),
      iconTransformation(extent={{-120,100},{-100,120}})));
  CDL.Interfaces.RealInput TChiWatSupSet(final unit="K", final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint" annotation (Placement(
        transformation(extent={{-220,110},{-180,150}}), iconTransformation(
          extent={{-120,80},{-100,100}})));
  CDL.Interfaces.RealInput                        TChiWatRet(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-220,60},{-180,100}}),
      iconTransformation(extent={{-120,60},{-100,80}})));
  CDL.Interfaces.RealInput                        VChiWat_flow(final quantity="VolumeFlowRate",
      final unit="m3/s")
                       "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-220,10},{-180,50}}),
      iconTransformation(extent={{-120,40},{-100,60}})));
  CDL.Interfaces.BooleanInput                        uWseSta "Waterside economizer status" annotation (
     Placement(transformation(extent={{-220,-280},{-180,-240}}),
        iconTransformation(extent={{-120,-110},{-100,-90}})));
  CDL.Interfaces.RealInput                        uTowFanSpeMax "Maximum cooling tower fan speed"
    annotation (Placement(transformation(extent={{-220,-250},{-180,-210}}),
        iconTransformation(extent={{-120,-90},{-100,-70}})));
  CDL.Interfaces.RealInput                        TWsePre(final unit="1")
    "Predicted waterside economizer outlet temperature" annotation (Placement(
        transformation(extent={{-220,-210},{-180,-170}}),
                                                        iconTransformation(
          extent={{-120,-70},{-100,-50}})));
  CDL.Interfaces.RealInput TChiWatSup(final unit="K", final quantity="ThermodynamicTemperature")
    "Chilled water return temperature" annotation (Placement(transformation(
          extent={{-220,-180},{-180,-140}}), iconTransformation(extent={{-120,10},
            {-100,30}})));
  CDL.Interfaces.RealInput dpChiWatPum(final unit="Pa", final quantity="PressureDifference")
    "Chilled water pump differential static pressure" annotation (Placement(
        transformation(extent={{-220,-150},{-180,-110}}), iconTransformation(
          extent={{-120,-40},{-100,-20}})));
  CDL.Interfaces.RealInput dpChiWatPumSet(final unit="Pa", final quantity="PressureDifference")
    "Chilled water pump differential static pressure setpoint" annotation (
      Placement(transformation(extent={{-220,-120},{-180,-80}}),
        iconTransformation(extent={{-120,-20},{-100,0}})));
equation
  connect(booToInt.y, addInt.u1) annotation (Line(points={{131,10},{134,10},{134,
          6},{148,6}}, color={255,127,0}));
  connect(booToInt1.y, addInt.u2) annotation (Line(points={{131,-30},{134,-30},{
          134,-6},{148,-6}}, color={255,127,0}));
  connect(addInt.y, y)
    annotation (Line(points={{171,0},{190,0}}, color={255,127,0}));
  connect(staCap.yStaNom,PLRs. uStaCapNom) annotation (Line(points={{-99,-63},{-74,
          -63},{-74,-5},{-61,-5}},     color={0,0,127}));
  connect(staCap.yStaUpNom,PLRs. uStaUpCapNom) annotation (Line(points={{-99,-67},
          {-72,-67},{-72,-7},{-61,-7}},      color={0,0,127}));
  connect(staCap.yStaDowNom,PLRs. uStaDowCapNom) annotation (Line(points={{-99,-71},
          {-70,-71},{-70,-9},{-61,-9}},      color={0,0,127}));
  connect(staCap.yStaUpMin,PLRs. uStaUpCapMin) annotation (Line(points={{-99,-76},
          {-66,-76},{-66,-11},{-61,-11}},      color={0,0,127}));
  connect(staCap.yStaMin,PLRs. uStaCapMin) annotation (Line(points={{-99,-78},{-64,
          -78},{-64,-13},{-61,-13}},     color={0,0,127}));
  connect(staUp.y, booToInt.u)
    annotation (Line(points={{81,10},{108,10}}, color={255,0,255}));
  connect(staDow.y, booToInt1.u)
    annotation (Line(points={{81,-30},{108,-30}}, color={255,0,255}));
  connect(capReq.y, PLRs.uCapReq) annotation (Line(points={{-99,-10},{-80,-10},{
          -80,-3},{-61,-3}}, color={0,0,127}));
  connect(uSta, PLRs.uSta) annotation (Line(points={{-200,180},{-70,180},{-70,-1},
          {-61,-1}}, color={255,127,0}));
  connect(uSta, staCap.uSta) annotation (Line(points={{-200,180},{-130,180},{-130,
          -70},{-122,-70}}, color={255,127,0}));
  connect(TChiWatSupSet, capReq.TChiWatSupSet) annotation (Line(points={{-200,130},
          {-140,130},{-140,-5},{-121,-5}}, color={0,0,127}));
  connect(TChiWatRet, capReq.TChiWatRet) annotation (Line(points={{-200,80},{-148,
          80},{-148,-10},{-121,-10}}, color={0,0,127}));
  connect(VChiWat_flow, capReq.VChiWat_flow) annotation (Line(points={{-200,30},
          {-160,30},{-160,-15},{-121,-15}}, color={0,0,127}));
  connect(PLRs.y, staUp.uOplr) annotation (Line(points={{-39,-3},{-20,-3},{-20,
          0},{-10,0},{-10,20},{59,20}},
                                     color={0,0,127}));
  connect(PLRs.yStaUp, staUp.uSplrUp) annotation (Line(points={{-39,-11},{-8,
          -11},{-8,18},{59,18}},
                            color={0,0,127}));
  connect(PLRs.yUp, staUp.uOplrUp) annotation (Line(points={{-39,-5},{-6,-5},{
          -6,15},{59,15}},
                        color={0,0,127}));
  connect(PLRs.yUpMin, staUp.uOplrUpMin) annotation (Line(points={{-39,-17},{-4,
          -17},{-4,13},{59,13}}, color={0,0,127}));
  connect(PLRs.yDow, staDow.uOplrDow) annotation (Line(points={{-39,-7},{2,-7},
          {2,-18},{59,-18}},color={0,0,127}));
  connect(PLRs.yStaDow, staDow.uSplrDow) annotation (Line(points={{-39,-13},{0,
          -13},{0,-20},{59,-20}},  color={0,0,127}));
  connect(PLRs.y, staDow.uOplr) annotation (Line(points={{-39,-3},{4,-3},{4,-22},
          {59,-22}},      color={0,0,127}));
  connect(PLRs.yMin, staDow.uOplrMin) annotation (Line(points={{-39,-19},{-20,
          -19},{-20,-24},{59,-24}},
                               color={0,0,127}));
  connect(dpChiWatPumSet, staDow.dpChiWatPumSet) annotation (Line(points={{-200,
          -100},{0,-100},{0,-26},{59,-26}}, color={0,0,127}));
  connect(dpChiWatPum, staDow.dpChiWatPum) annotation (Line(points={{-200,-130},
          {2,-130},{2,-28},{59,-28}}, color={0,0,127}));
  connect(TChiWatSupSet, staUp.TChiWatSupSet) annotation (Line(points={{-200,
          130},{6,130},{6,10},{59,10}},
                                   color={0,0,127}));
  connect(TChiWatSupSet, staDow.TChiWatSupSet) annotation (Line(points={{-200,
          130},{6,130},{6,-32},{59,-32}},
                                     color={0,0,127}));
  connect(TChiWatSup, staDow.TChiWatSup) annotation (Line(points={{-200,-160},{
          6,-160},{6,-34},{59,-34}},
                                   color={0,0,127}));
  connect(TChiWatSup, staUp.TChiWatSup) annotation (Line(points={{-200,-160},{8,
          -160},{8,8},{59,8}}, color={0,0,127}));
  connect(TWsePre, staDow.TWsePre) annotation (Line(points={{-200,-190},{10,
          -190},{10,-30},{59,-30}},
                              color={0,0,127}));
  connect(dpChiWatPumSet, staUp.dpChiWatPumSet) annotation (Line(points={{-200,
          -100},{12,-100},{12,5},{59,5}},
                                    color={0,0,127}));
  connect(dpChiWatPum, staUp.dpChiWatPum) annotation (Line(points={{-200,-130},
          {14,-130},{14,3},{59,3}},color={0,0,127}));
  connect(uTowFanSpeMax, staDow.uTowFanSpeMax) annotation (Line(points={{-200,
          -230},{16,-230},{16,-36},{59,-36}},
                                        color={0,0,127}));
  connect(uSta, staUp.uChiSta) annotation (Line(points={{-200,180},{18,180},{18,
          0},{59,0}}, color={255,127,0}));
  connect(uSta, staDow.uChiSta) annotation (Line(points={{-200,180},{20,180},{
          20,-40},{59,-40}},
                          color={255,127,0}));
  connect(uWseSta, staDow.uWseSta) annotation (Line(points={{-200,-260},{22,
          -260},{22,-38},{59,-38}},
                     color={255,0,255}));
  annotation (defaultComponentName = "staChaPosDis",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}),          Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-180,-280},{180,200}})),
Documentation(info="<html>
<p>
Outputs the chiller stage change signal

fixme: add a stage availability input signal, which will
remove the stage change delay if the stage is unavailable, to
allow for a change to the next available stage at the next instant.  

add WSE enable at plant enable part (input, output, predicted temperature) and at staging down from 1.
</p>
</html>",
revisions="<html>
<ul>
<li>
January xx, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Change;
