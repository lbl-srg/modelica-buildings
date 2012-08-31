within Buildings.Fluid.HeatExchangers.DXCoils.Examples;
model SingleSpeedValidationPLR
  "Validation model for single speed DX coil with PLR=1"
  package Medium = Buildings.Media.GasesConstantDensity.MoistAirUnsaturated;
  extends Modelica.Icons.Example;
 parameter Modelica.SIunits.Power Q_flow_nominal = datCoi.per[1].nomVal.Q_flow_nominal
    "Nominal power";
 parameter Modelica.SIunits.MassFlowRate m_flow_nominal = datCoi.per[1].nomVal.m_flow_nominal
    "Nominal mass flow rate";
 parameter Modelica.SIunits.Pressure dp_nominal = 1141
    "Pressure drop at m_flow_nominal";
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 101325,
    nPorts=1,
    T=303.15) "Sink"
    annotation (Placement(transformation(extent={{40,-20},{20,0}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 101325 + dp_nominal,
    use_T_in=true,
    nPorts=1,
    use_p_in=true,
    use_X_in=true,
    T=299.85) "Source"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{140,-140},{160,-120}})));
  Buildings.Fluid.HeatExchangers.DXCoils.SingleSpeed sinSpeDX(
    redeclare package Medium = Medium,
    dp_nominal=dp_nominal,
    datCoi=datCoi,
    T_start=datCoi.per[1].nomVal.TIn_nominal) "Single speed DX coil"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));

  Modelica.Blocks.Routing.Multiplex2 mux "Converts in an array"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Utilities.IO.BCVTB.From_degC TCIn_K "Converts degC to K"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Utilities.IO.BCVTB.From_degC TIn_K "Converts degC to K"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Modelica.Blocks.Math.Mean TOutMea(f=1/3600)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Buildings.Utilities.IO.BCVTB.To_degC TOutDegC
    annotation (Placement(transformation(extent={{120,80},{140,100}})));
  Modelica.Blocks.Sources.RealExpression TOut(y=sinSpeDX.vol.T)
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Modelica.Blocks.Math.Mean XOutMea(f=1/3600)
    annotation (Placement(transformation(extent={{80,120},{100,140}})));
  Modelica.Blocks.Sources.RealExpression XOut(y=sum(sinSpeDX.vol.Xi))
    annotation (Placement(transformation(extent={{40,120},{60,140}})));
  Modelica.Blocks.Math.Mean Q_flowMea(f=1/3600) "Mean of cooling rate"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Modelica.Blocks.Sources.RealExpression Q_flow(y=sinSpeDX.pwr.Q_flow)
    "Cooling rate"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Modelica.Blocks.Math.Mean Q_flowSenMea(f=1/3600)
    "Mean of sensible cooling rate"
    annotation (Placement(transformation(extent={{0,120},{20,140}})));
  Modelica.Blocks.Sources.RealExpression Q_flowSen(y=sinSpeDX.pwr.senHea.y)
    "Sensible cooling rate"
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));
  Modelica.Blocks.Math.Mean PMea(f=1/3600) "Mean of power"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Modelica.Blocks.Math.Add add(k1=-1)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Blocks.Sources.Constant XInMoiAir(k=1.0) "Moist air fraction = 1"
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})));
  Modelica.Blocks.Math.Division shrEPlu "EnergyPlus result: SHR"
    annotation (Placement(transformation(extent={{80,-120},{100,-100}})));
  Modelica.Blocks.Sources.Pulse p(
    nperiod=1,
    offset=101325,
    width=100,
    period=36000,
    startTime=25200,
    amplitude=1086) "Pressure"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  Modelica.Blocks.Sources.RealExpression XInMod(y=XIn.y/(1 + XIn.y))
    "Modified XIn"
    annotation (Placement(transformation(extent={{-140,-54},{-120,-34}})));
  Modelica.Blocks.Sources.RealExpression XOutEPluMod(y=XOutEPlu.y/(1 + XOutEPlu.y))
    "Modified XOut of energyPlus to comapre with the model results"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  Modelica.Blocks.Sources.BooleanTable onOff(startValue=true, table={0,25200,26412.08951,
        28800,30665.60084,32400,34326.70384,36000,38060.56574,39600,41822.43884,
        43200,45504.64424,46800,49239.58691,50400,52889.2799,54000,56492.0477,57600,
        60017.41664})
    "EnergyPlus PLR converted into on-off signal for this model"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  Modelica.Blocks.Sources.TimeTable TCIn(table=[0,21.1; 3600,21.1; 3600,
        20.80833333; 7200,20.80833333; 7200,20.89166667; 10800,20.89166667;
        10800,21.1; 14400,21.1; 14400,20.80833333; 18000,20.80833333; 18000,
        20.6; 21600,20.6; 21600,20.89166667; 25200,20.89166667; 25200,21.45;
        28800,21.45; 28800,22.63333333; 32400,22.63333333; 32400,23.3; 36000,
        23.3; 36000,25.575; 39600,25.575; 39600,28.19166667; 43200,28.19166667;
        43200,27.90833333; 46800,27.90833333; 46800,26.90833333; 50400,
        26.90833333; 50400,26.7; 54000,26.7; 54000,26.05833333; 57600,
        26.05833333; 57600,24.60833333; 61200,24.60833333; 61200,23.55; 64800,
        23.55; 64800,23.3; 68400,23.3; 68400,23.00833333; 72000,23.00833333;
        72000,22.8; 75600,22.8; 75600,22.15833333; 79200,22.15833333; 79200,
        21.35; 82800,21.35; 82800,21.1; 86400,21.1])
    "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));
  Modelica.Blocks.Sources.TimeTable TIn(table=[0,29.34912216; 3600,29.34912216;
        3600,29.01780747; 7200,29.01780747; 7200,28.76316446; 10800,28.76316446;
        10800,28.53370769; 14400,28.53370769; 14400,28.29481621; 18000,
        28.29481621; 18000,28.08801492; 21600,28.08801492; 21600,28.04615077;
        25200,28.04615077; 25200,24.08547489; 28800,24.08547489; 28800,
        24.09291165; 32400,24.09291165; 32400,24.206805; 36000,24.206805; 36000,
        24.37801616; 39600,24.37801616; 39600,24.56445536; 43200,24.56445536;
        43200,24.52637397; 46800,24.52637397; 46800,24.39263734; 50400,
        24.39263734; 50400,24.33303696; 54000,24.33303696; 54000,24.27485833;
        57600,24.27485833; 57600,24.16657976; 61200,24.16657976; 61200,
        35.62447215; 64800,35.62447215; 64800,32.89603218; 68400,32.89603218;
        68400,31.14934092; 72000,31.14934092; 72000,30.65894707; 75600,
        30.65894707; 75600,30.28881583; 79200,30.28881583; 79200,29.91834847;
        82800,29.91834847; 82800,29.61457284; 86400,29.61457284])
    "Coil inlet temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  Modelica.Blocks.Sources.TimeTable XIn(table=[0,0.007749604; 3600,0.007749604;
        3600,0.007749604; 7200,0.007749604; 7200,0.007749604; 10800,0.007749604;
        10800,0.007749604; 14400,0.007749604; 14400,0.007749604; 18000,0.007749604;
        18000,0.007749604; 21600,0.007749604; 21600,0.007842352; 25200,0.007842352;
        25200,0.008569019; 28800,0.008569019; 28800,0.008521115; 32400,0.008521115;
        32400,0.008295639; 36000,0.008295639; 36000,0.008140504; 39600,0.008140504;
        39600,0.007933561; 43200,0.007933561; 43200,0.007802791; 46800,0.007802791;
        46800,0.007783859; 50400,0.007783859; 50400,0.007736453; 54000,0.007736453;
        54000,0.007746831; 57600,0.007746831; 57600,0.007830508; 61200,0.007830508;
        61200,0.007651088; 64800,0.007651088; 64800,0.007749378; 68400,0.007749378;
        68400,0.00774935; 72000,0.00774935; 72000,0.00774935; 75600,0.00774935;
        75600,0.00774935; 79200,0.00774935; 79200,0.00774935; 82800,0.00774935;
        82800,0.00774935; 86400,0.00774935]) "Water fraction of moist air"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  Modelica.Blocks.Sources.TimeTable TOutEPlu(table=[0,29.34912216; 3600,29.34912216;
        3600,29.01780747; 7200,29.01780747; 7200,28.76316446; 10800,28.76316446;
        10800,28.53370769; 14400,28.53370769; 14400,28.29481621; 18000,28.29481621;
        18000,28.08801492; 21600,28.08801492; 21600,28.04615077; 25200,28.04615077;
        25200,19.7749043; 28800,19.7749043; 28800,17.55329917; 32400,17.55329917;
        32400,17.32376986; 36000,17.32376986; 36000,16.92227906; 39600,16.92227906;
        39600,16.40910685; 43200,16.40910685; 43200,16.00455777; 46800,16.00455777;
        46800,15.38334539; 50400,15.38334539; 50400,15.12866538; 54000,15.12866538;
        54000,15.0700847; 57600,15.0700847; 57600,15.29020079; 61200,15.29020079;
        61200,35.62447215; 64800,35.62447215; 64800,32.89603218; 68400,32.89603218;
        68400,31.14934092; 72000,31.14934092; 72000,30.65894707; 75600,30.65894707;
        75600,30.28881583; 79200,30.28881583; 79200,29.91834847; 82800,29.91834847;
        82800,29.61457284; 86400,29.61457284])
    "EnergyPlus result: outlet temperature"
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));
  Modelica.Blocks.Sources.TimeTable PEPlu(table=[0,0; 3600,0; 3600,0; 7200,0;
        7200,0; 10800,0; 10800,0; 14400,0; 14400,0; 18000,0; 18000,0; 21600,0;
        21600,0; 25200,0; 25200,2556.074454; 28800,2556.074454; 28800,
        3900.758537; 32400,3900.758537; 32400,4038.437128; 36000,4038.437128;
        36000,4413.349406; 39600,4413.349406; 39600,4879.89386; 43200,
        4879.89386; 43200,5012.839823; 46800,5012.839823; 46800,5200.788337;
        50400,5200.788337; 50400,5275.622452; 54000,5275.622452; 54000,
        5235.32003; 57600,5235.32003; 57600,5003.222568; 61200,5003.222568;
        61200,0; 64800,0; 64800,0; 68400,0; 68400,0; 72000,0; 72000,0; 75600,0;
        75600,0; 79200,0; 79200,0; 82800,0; 82800,0; 86400,0])
    "EnergyPlus result: electric power"
    annotation (Placement(transformation(extent={{-80,-140},{-60,-120}})));
  Modelica.Blocks.Sources.TimeTable XOutEPlu(table=[0,0.007749604; 3600,
        0.007749604; 3600,0.007749604; 7200,0.007749604; 7200,0.007749604;
        10800,0.007749604; 10800,0.007749604; 14400,0.007749604; 14400,
        0.007749604; 18000,0.007749604; 18000,0.007749604; 21600,0.007749604;
        21600,0.007842352; 25200,0.007842352; 25200,0.008284084; 28800,
        0.008284084; 28800,0.008062422; 32400,0.008062422; 32400,0.007889653;
        36000,0.007889653; 36000,0.007782043; 39600,0.007782043; 39600,
        0.007651344; 43200,0.007651344; 43200,0.007539268; 46800,0.007539268;
        46800,0.007482329; 50400,0.007482329; 50400,0.007434045; 54000,
        0.007434045; 54000,0.007427886; 57600,0.007427886; 57600,0.00747109;
        61200,0.00747109; 61200,0.007651088; 64800,0.007651088; 64800,
        0.007749378; 68400,0.007749378; 68400,0.00774935; 72000,0.00774935;
        72000,0.00774935; 75600,0.00774935; 75600,0.00774935; 79200,0.00774935;
        79200,0.00774935; 82800,0.00774935; 82800,0.00774935; 86400,0.00774935])
    "EnergyPlus result: outlet water mass fraction"
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));
  Modelica.Blocks.Sources.TimeTable Q_flowSenEPlu(table=[0,0; 3600,0; 3600,0;
        7200,0; 7200,0; 10800,0; 10800,0; 14400,0; 14400,0; 18000,0; 18000,0;
        21600,0; 21600,0; 25200,0; 25200,-7377.624185; 28800,-7377.624185;
        28800,-11188.63306; 32400,-11188.63306; 32400,-11772.51003; 36000,-11772.51003;
        36000,-12749.52461; 39600,-12749.52461; 39600,-13942.56126; 43200,-13942.56126;
        43200,-14566.11424; 46800,-14566.11424; 46800,-15397.75493; 50400,-15397.75493;
        50400,-15729.77819; 54000,-15729.77819; 54000,-15730.28896; 57600,-15730.28896;
        57600,-15170.2822; 61200,-15170.2822; 61200,0; 64800,0; 64800,0; 68400,
        0; 68400,0; 72000,0; 72000,0; 75600,0; 75600,0; 79200,0; 79200,0; 82800,
        0; 82800,0; 86400,0]) "EnergyPlus result: sensible heat flow "
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  Modelica.Blocks.Sources.TimeTable Q_flowEPlu(table=[0,-1e-09; 3600,-1e-09;
        3600,-1e-09; 7200,-1e-09; 7200,-1e-09; 10800,-1e-09; 10800,-1e-09;
        14400,-1e-09; 14400,-1e-09; 18000,-1e-09; 18000,-1e-09; 21600,-1e-09;
        21600,-1e-09; 25200,-1e-09; 25200,-8594.25443; 28800,-8594.25443; 28800,
        -13147.61467; 32400,-13147.61467; 32400,-13506.54954; 36000,-13506.54954;
        36000,-14280.75933; 39600,-14280.75933; 39600,-15148.27499; 43200,-15148.27499;
        43200,-15691.92779; 46800,-15691.92779; 46800,-16685.8164; 50400,-16685.8164;
        50400,-17021.53647; 54000,-17021.53647; 54000,-17092.62738; 57600,-17092.62738;
        57600,-16705.37339; 61200,-16705.37339; 61200,-1e-09; 64800,-1e-09;
        64800,-1e-09; 68400,-1e-09; 68400,-1e-09; 72000,-1e-09; 72000,-1e-09;
        75600,-1e-09; 75600,-1e-09; 79200,-1e-09; 79200,-1e-09; 82800,-1e-09;
        82800,-1e-09; 86400,-1e-09]) "EnergyPlus result: heat flow"
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));
  Data.CoilData datCoi(nSpe=1, per={
        Buildings.Fluid.HeatExchangers.DXCoils.Data.BaseClasses.Generic(
        spe=1800,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.Data.BaseClasses.NominalValues(
          Q_flow_nominal=-25237.66,
          COP_nominal=3,
          SHR_nominal=0.775047,
          m_flow_nominal=1.72),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.Data.PerformanceCurves.Curve_II())})
    "Coil data"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
equation
  connect(sou.ports[1], sinSpeDX.port_a)
                                        annotation (Line(
      points={{-20,-10},{-16,-10},{-16,10},{-10,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sinSpeDX.port_b, sin.ports[1])
                                        annotation (Line(
      points={{10,10},{16,10},{16,-10},{20,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mux.y, sou.X_in)          annotation (Line(
      points={{-59,-50},{-52,-50},{-52,-14},{-42,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TCIn_K.Kelvin, sinSpeDX.TConIn)  annotation (Line(
      points={{-79,69.8},{-66.5,69.8},{-66.5,13},{-11,13}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TIn_K.Kelvin, sou.T_in)    annotation (Line(
      points={{-79,-10.2},{-51.7,-10.2},{-51.7,-6},{-42,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TOut.y, TOutMea.u)
                           annotation (Line(
      points={{61,90},{78,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TOutMea.y, TOutDegC.Kelvin)
                                    annotation (Line(
      points={{101,90},{118,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XOut.y, XOutMea.u)
                           annotation (Line(
      points={{61,130},{78,130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Q_flow.y, Q_flowMea.u)   annotation (Line(
      points={{-19,90},{-2,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Q_flowSen.y, Q_flowSenMea.u)   annotation (Line(
      points={{-19,130},{-2,130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XInMoiAir.y, add.u2)
                           annotation (Line(
      points={{-119,-110},{-112,-110},{-112,-96},{-102,-96}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, mux.u2[1]) annotation (Line(
      points={{-79,-90},{-68,-90},{-68,-68},{-96,-68},{-96,-56},{-82,-56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sinSpeDX.P, PMea.u) annotation (Line(
      points={{11,18},{14,18},{14,50},{18,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p.y, sou.p_in) annotation (Line(
      points={{-119,30},{-74,30},{-74,-2},{-42,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XInMod.y, mux.u1[1]) annotation (Line(
      points={{-119,-44},{-82,-44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XInMod.y, add.u1) annotation (Line(
      points={{-119,-44},{-110,-44},{-110,-84},{-102,-84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(onOff.y, sinSpeDX.on) annotation (Line(
      points={{-99,110},{-54,110},{-54,20},{-11,20}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(TCIn.y, TCIn_K.Celsius) annotation (Line(
      points={{-119,70},{-110.5,70},{-110.5,69.6},{-102,69.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TIn.y, TIn_K.Celsius) annotation (Line(
      points={{-119,-10},{-110.5,-10},{-110.5,-10.4},{-102,-10.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Q_flowSenEPlu.y, shrEPlu.u1) annotation (Line(
      points={{61,-90},{70,-90},{70,-104},{78,-104}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Q_flowEPlu.y, shrEPlu.u2) annotation (Line(
      points={{61,-130},{68,-130},{68,-116},{78,-116}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-160,-140},
            {160,140}}),       graphics),
             __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/Examples/SingleSpeedValidationPLR.mos"
        "Simulate and plot"),
    experiment(StopTime=3600),
    experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-160,-140},{160,140}})),
            Documentation(info="<html>
<p>
This validates single speed DX cooling coil: 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.SingleSpeed\"> 
Buildings.Fluid.HeatExchangers.DXCoils.SingleSpeed</a> 
</p>
<p>
EnergyPlus results are generated using example file DXCoilSystemAuto.idf from EnergyPlus 7.1.
On summer design day for mentioned input file in EnergyPlus PLR is &lt; 1. 
Similar effect is achieved in this example by turning on the coil only for the period 
t = EnergyPlus output reporting period * PLR.
This results in on-off cycle and fluctuating results at output of the model.
To compare the results, model outputs are averaged over 3600 sec. This leads to 3600 lag between 
model results and EnergyPlus results observed in the plots. 
</p>
</html>",
revisions="<html>
<ul>
<li>
August 20, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>

</html>"));
end SingleSpeedValidationPLR;
