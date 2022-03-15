within Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences.Validation;
block SupplyAirTemperature
  "Validation model for supply air temperature setpoint subsequence"

  extends Modelica.Icons.Example;

  Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences.SupplyAirTemperature
    TSupAir(have_coolingCoil=true, have_heatingCoil=true)
    annotation (Placement(transformation(extent={{-50,60},{-30,80}})));
  Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences.SupplyAirTemperature TSupAir3(
      have_coolingCoil=true, have_heatingCoil=false)
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences.SupplyAirTemperature TSupAir2(
      have_coolingCoil=false, have_heatingCoil=true)
    annotation (Placement(transformation(extent={{-50,-100},{-30,-80}})));
  CDL.Continuous.Sources.Sine sin(
    amplitude=20,
    freqHz=1/50,
    offset=273.15 + 23) "Supply air temperature signal"
    annotation (Placement(transformation(extent={{-90,60},{-70,80}})));

  CDL.Continuous.Sources.Sine sin3(
    amplitude=20,
    freqHz=1/50,
    offset=273.15 + 23) "Supply air temperature signal"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  CDL.Continuous.Sources.Sine sin5(
    amplitude=0.5,
    freqHz=1/100,
    offset=0.5) "Cooling loop signal"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
  CDL.Continuous.Sources.Sine sin6(
    amplitude=20,
    freqHz=1/50,
    offset=273.15 + 23) "Supply air temperature signal"
    annotation (Placement(transformation(extent={{-90,-100},{-70,-80}})));
  CDL.Continuous.Sources.Sine sin8(
    amplitude=0.5,
    freqHz=1/100,
    offset=0.5) "Heating loop signal"
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
  Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences.SupplyAirTemperature
    TSupAir1(have_coolingCoil=true, have_heatingCoil=true)
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  CDL.Continuous.Sources.Sine sin4(
    amplitude=20,
    freqHz=1/50,
    offset=273.15 + 23) "Supply air temperature signal"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  CDL.Continuous.Sources.Constant con(k=273.15 + 21)
    "Zone heating temperature setpoint"
    annotation (Placement(transformation(extent={{-90,120},{-70,140}})));
  CDL.Continuous.Sources.Constant con1(k=273.15 + 25)
    "Zone cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));
  CDL.Continuous.Sources.Constant con2(k=273.15 + 21)
    "Zone heating temperature setpoint"
    annotation (Placement(transformation(extent={{40,120},{60,140}})));
  CDL.Continuous.Sources.Constant con3(k=273.15 + 25)
    "Zone cooling temperature setpoint"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  CDL.Continuous.Sources.Constant con4(k=273.15 + 21)
    "Zone heating temperature setpoint"
    annotation (Placement(transformation(extent={{-90,-40},{-70,-20}})));
  CDL.Continuous.Sources.Constant con6(k=273.15 + 25)
    "Zone cooling temperature setpoint"
    annotation (Placement(transformation(extent={{20,-130},{40,-110}})));
  CDL.Continuous.Sources.Constant con5(k=0.25) "Heating loop signal"
    annotation (Placement(transformation(extent={{-90,90},{-70,110}})));
  CDL.Continuous.Sources.Constant con7(k=0) "Heating loop signal"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  CDL.Continuous.Sources.Constant con8(k=0) "Cooling loop signal"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  CDL.Continuous.Sources.Constant con9(k=0.25) "Cooling loop signal"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
equation
  connect(sin.y, TSupAir.TAirSup)
    annotation (Line(points={{-68,70},{-52,70}}, color={0,0,127}));
  connect(sin6.y, TSupAir2.TAirSup)
    annotation (Line(points={{-68,-90},{-52,-90}}, color={0,0,127}));
  connect(sin8.y, TSupAir2.uHea) annotation (Line(points={{-68,-60},{-60,-60},{
          -60,-86},{-52,-86}}, color={0,0,127}));
  connect(sin4.y,TSupAir1. TAirSup)
    annotation (Line(points={{62,70},{78,70}}, color={0,0,127}));
  connect(con.y, TSupAir.TZonSetHea) annotation (Line(points={{-68,130},{-56,
          130},{-56,78},{-52,78}}, color={0,0,127}));
  connect(con1.y, TSupAir.TZonSetCoo) annotation (Line(points={{-68,10},{-56,10},
          {-56,62},{-52,62}}, color={0,0,127}));
  connect(con2.y, TSupAir1.TZonSetHea) annotation (Line(points={{62,130},{72,
          130},{72,78},{78,78}}, color={0,0,127}));
  connect(con3.y, TSupAir1.TZonSetCoo) annotation (Line(points={{62,10},{72,10},
          {72,62},{78,62}}, color={0,0,127}));
  connect(con4.y, TSupAir2.TZonSetHea) annotation (Line(points={{-68,-30},{-56,
          -30},{-56,-82},{-52,-82}}, color={0,0,127}));
  connect(con6.y, TSupAir3.TZonSetCoo) annotation (Line(points={{42,-120},{54,
          -120},{54,-78},{58,-78}}, color={0,0,127}));
  connect(con5.y, TSupAir.uHea) annotation (Line(points={{-68,100},{-60,100},{
          -60,74},{-52,74}}, color={0,0,127}));
  connect(con7.y, TSupAir1.uHea) annotation (Line(points={{62,100},{68,100},{68,
          74},{78,74}}, color={0,0,127}));
  connect(con8.y, TSupAir.uCoo) annotation (Line(points={{-68,40},{-60,40},{-60,
          66},{-52,66}}, color={0,0,127}));
  connect(con9.y, TSupAir1.uCoo) annotation (Line(points={{62,40},{70,40},{70,
          66},{78,66}}, color={0,0,127}));
  connect(sin5.y, TSupAir3.uCoo) annotation (Line(points={{42,-90},{52,-90},{52,
          -74},{58,-74}}, color={0,0,127}));
  connect(sin3.y, TSupAir3.TAirSup) annotation (Line(points={{42,-60},{52,-60},
          {52,-70},{58,-70}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,140}})),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/FanCoilUnit/Subsequences/Validation/SupplyAirTemperature.mos"
    "Simulate and plot"));
end SupplyAirTemperature;
