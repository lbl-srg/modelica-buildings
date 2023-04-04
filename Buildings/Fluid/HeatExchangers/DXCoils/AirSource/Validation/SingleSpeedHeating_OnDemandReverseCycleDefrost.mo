within Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Validation;
model SingleSpeedHeating_OnDemandReverseCycleDefrost
  "Validation model for single speed heating DX coil with defrost operation"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air
    "Medium model";

  parameter Modelica.Units.SI.Power Q_flow_nominal=datCoi.sta[1].nomVal.Q_flow_nominal
    "Nominal power";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=datCoi.sta[1].nomVal.m_flow_nominal
    "Nominal mass flow rate";

  parameter Modelica.Units.SI.PressureDifference dp_nominal=1141
    "Pressure drop at m_flow_nominal";

  parameter Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.CoilHeatTransfer
    datCoi(
      activate_CooCoi=false,
      sta={Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.NominalValues(
          activate_CooCoi=false,
          Q_flow_nominal=15000,
          COP_nominal=2.75,
          SHR_nominal=1,
          m_flow_nominal=0.782220983308365,
          TEvaIn_nominal=273.15 + 6,
          TConIn_nominal=273.15 + 21),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Examples.PerformanceCurves.DXHeating_Curve_II())},
      nSta=1)
    "Coil heat transfer data"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    final p(displayUnit="Pa") = 101325,
    final nPorts=1,
    final T=294.15)
    "Sink"
    annotation (Placement(transformation(extent={{40,-20},{20,0}})));

  Buildings.Fluid.HeatExchangers.DXCoils.AirSource.SingleSpeedHeating sinSpeDX(
    datCoi(
      final nSta=datCoi.nSta,
      final minSpeRat=datCoi.minSpeRat,
      final sta=datCoi.sta),
    redeclare package Medium = Medium,
    final dp_nominal=dp_nominal,
    final T_start=datCoi.sta[1].nomVal.TEvaIn_nominal,
    final from_dp=true,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final datDef=datDef)
    "Single speed DX heating coil"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));

  Buildings.Utilities.IO.BCVTB.From_degC TEvaIn_K
    "Converts degC to K"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));

  Buildings.Utilities.IO.BCVTB.From_degC TConIn_K
    "Converts degC to K"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

  Modelica.Blocks.Math.Mean TOutMea(
    final f=1/3600)
    "Mean of measured outlet air temperature"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));

  Buildings.Utilities.IO.BCVTB.To_degC TOutDegC
    "Convert measured outlet air temperature to deg C"
    annotation (Placement(transformation(extent={{120,80},{140,100}})));

  Modelica.Blocks.Sources.RealExpression TOut(
    final y=sinSpeDX.vol.T)
    "Measured temperature of outlet air"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));

  Modelica.Blocks.Math.Mean XConOutMea(
    final f=1/3600)
    "Mean of measured outlet air humidity ratio (Total air)"
    annotation (Placement(transformation(extent={{80,120},{100,140}})));

  Modelica.Blocks.Sources.RealExpression XConOut(
    final y=sum(sinSpeDX.vol.Xi))
    "Measured humidity ratio of outlet air"
    annotation (Placement(transformation(extent={{40,120},{60,140}})));

  Modelica.Blocks.Math.Mean Q_flowMea(
    final f=1/3600)
    "Mean of cooling rate"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));

  Modelica.Blocks.Math.Mean PMea(
    final f=1/3600)
    "Mean of power"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay PEPlu(
    final samplePeriod=3600)
    "Total power consumption from EnergyPlus"
    annotation (Placement(transformation(extent={{-68,-140},{-48,-120}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay Q_flowEPlu(
    final samplePeriod=3600)
    "Heat transfer to airloop from EnergyPlus"
    annotation (Placement(transformation(extent={{100,-140},{120,-120}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay TOutEPlu(
    final samplePeriod=3600,
    final y_start=29.34948133)
    "Outlet temperature from EnergyPlus"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay XConOutEPlu(
    final samplePeriod=1)
    "Outlet air humidity ratio from EnergyPlus"
    annotation (Placement(transformation(extent={{30,-140},{50,-120}})));

  Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Defrost
    datDef(
    final defOpe=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostOperation.reverseCycle,
    final defTri=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostTimeMethods.onDemand,
    final QDefResCap=10500,
    final QCraCap=200,
    final defEIRFunT={0.297145,0.0430933,-0.000748766,0.00597727,0.000482112,-0.000956448},
    final PLFraFunPLR={1})
    "Defrost data"
    annotation (Placement(transformation(extent={{80,-6},{100,14}})));

  Buildings.Utilities.Psychrometrics.ToTotalAir toTotAirOut
    "Convert humidity ratio (dry air) to humidity ratio (total air) for outdoor air"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));

  Buildings.Utilities.Psychrometrics.ToTotalAir toTotAirEPlu
    "Convert humidity ratio (dry air) from EnergyPlus to humidity ratio (total air)"
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay PDefEPlu(
    final samplePeriod=1)
    "Defrost power from EnergyPlus"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay PCraEPlu(
    final samplePeriod=3600)
    "Cranckcase heater power from EnergyPlus"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));

  Modelica.Blocks.Sources.CombiTimeTable datRea(
    final tableOnFile=true,
    final fileName=ModelicaServices.ExternalReferences.loadResource("modelice://Buildings/Resources/Data/Fluid/HeatExchangers/DXCoils/AirSource/Validation/SingleSpeedHeating_OnDemandReverseCycleDefrost/DXCoilSystemAuto.dat"),
    final columns=2:18,
    final tableName="EnergyPlus",
    final smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "Reader for EnergyPlus example results"
    annotation (Placement(transformation(extent={{-152,110},{-132,130}})));

  Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Validation.BaseClasses.PLRToPulse
    plrToPul(
    final tPer=3600)
    "Convert PLR signal to on-off signal"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));

  Buildings.Fluid.Sources.MassFlowSource_T boundary(
    redeclare package Medium = Medium,
    final use_Xi_in=true,
    final use_m_flow_in=true,
    final use_T_in=true,
    final nPorts=1)
    "Mass flow source for coil inlet air"
    annotation (Placement(transformation(extent={{-48,-20},{-28,0}})));

  Buildings.Utilities.Psychrometrics.ToTotalAir toTotAirIn
    "Convert humidity ratio (dry air) to humidity ratio (total air) for coil inlet air"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));

equation
  connect(sinSpeDX.port_b, sin.ports[1])
    annotation (Line(
      points={{10,10},{16,10},{16,-10},{20,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TEvaIn_K.Kelvin, sinSpeDX.TOut) annotation (Line(
      points={{-79,79.8},{-66.5,79.8},{-66.5,13},{-11,13}},
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
  connect(XConOut.y,XConOutMea. u)
                           annotation (Line(
      points={{61,130},{78,130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sinSpeDX.QSen_flow, Q_flowMea.u) annotation (Line(points={{11,17},{20,
          17},{20,54},{-10,54},{-10,90},{-2,90}}, color={0,0,127}));
  connect(toTotAirOut.XiTotalAir, sinSpeDX.XOut) annotation (Line(points={{-79,50},
          {-20,50},{-20,1},{-11,1}}, color={0,0,127}));
  connect(toTotAirEPlu.XiTotalAir, XConOutEPlu.u)
    annotation (Line(points={{21,-130},{28,-130}}, color={0,0,127}));
  connect(sinSpeDX.P, PMea.u) annotation (Line(points={{11,19},{25.5,19},{25.5,20},
          {38,20}}, color={0,0,127}));
  connect(datRea.y[14], plrToPul.uPLR)
    annotation (Line(points={{-131,120},{-82,120}}, color={0,0,127}));
  connect(plrToPul.yEna, sinSpeDX.on) annotation (Line(points={{-58,120},{-26,120},
          {-26,18},{-11,18}}, color={255,0,255}));
  connect(datRea.y[1], TEvaIn_K.Celsius) annotation (Line(points={{-131,120},{-108,
          120},{-108,79.6},{-102,79.6}}, color={0,0,127}));
  connect(datRea.y[9], toTotAirOut.XiDry) annotation (Line(points={{-131,120},{-108,
          120},{-108,50},{-101,50}}, color={0,0,127}));
  connect(datRea.y[17], boundary.m_flow_in) annotation (Line(points={{-131,120},
          {-108,120},{-108,16},{-50,16},{-50,-2}}, color={0,0,127}));
  connect(TConIn_K.Kelvin, boundary.T_in) annotation (Line(points={{-79,-10.2},{
          -60,-10.2},{-60,-6},{-50,-6}}, color={0,0,127}));
  connect(toTotAirIn.XiTotalAir, boundary.Xi_in[1]) annotation (Line(points={{-79,
          -50},{-60,-50},{-60,-14},{-50,-14}}, color={0,0,127}));
  connect(datRea.y[5], TConIn_K.Celsius) annotation (Line(points={{-131,120},{-108,
          120},{-108,-10.4},{-102,-10.4}}, color={0,0,127}));
  connect(datRea.y[6], toTotAirIn.XiDry) annotation (Line(points={{-131,120},{-108,
          120},{-108,-50},{-101,-50}}, color={0,0,127}));
  connect(boundary.ports[1], sinSpeDX.port_a) annotation (Line(points={{-28,-10},
          {-18,-10},{-18,10},{-10,10}}, color={0,127,255}));
  connect(datRea.y[7], TOutEPlu.u) annotation (Line(points={{-131,120},{-108,120},
          {-108,-30},{-10,-30},{-10,-60},{-2,-60}}, color={0,0,127}));
  connect(datRea.y[8], toTotAirEPlu.XiDry) annotation (Line(points={{-131,120},{
          -108,120},{-108,-30},{-10,-30},{-10,-130},{-1,-130}}, color={0,0,127}));
  connect(datRea.y[3], PEPlu.u) annotation (Line(points={{-131,120},{-108,120},{
          -108,-30},{-10,-30},{-10,-108},{-74,-108},{-74,-130},{-70,-130}},
        color={0,0,127}));
  connect(datRea.y[2], Q_flowEPlu.u) annotation (Line(points={{-131,120},{-108,120},
          {-108,-30},{-10,-30},{-10,-108},{90,-108},{90,-130},{98,-130}}, color=
         {0,0,127}));
  connect(datRea.y[15], PDefEPlu.u) annotation (Line(points={{-131,120},{-108,120},
          {-108,-30},{-10,-30},{-10,-40},{98,-40}}, color={0,0,127}));
  connect(datRea.y[16], PCraEPlu.u) annotation (Line(points={{-131,120},{-108,120},
          {-108,-80},{98,-80}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-160,-140},
            {160,140}})),
             __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/AirSource/Validation/SingleSpeedHeating_OnDemandReverseCycleDefrost.mos"
        "Simulate and Plot"),
    experiment(Tolerance=1e-6, StopTime=86400),
            Documentation(info="<html>
<p>
This model validates the model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.AirSource.SingleSpeedHeating\">
Buildings.Fluid.HeatExchangers.DXCoils.AirSource.SingleSpeedHeating</a> with the 
defrost time fraction calculation <code>datDef.defTri</code> set to 
<code>DefrostTimeMethods.onDemand</code> and the defrost operation type 
<code>datDef.defOpe</code> set to <code>DefrostOperation.reverseCycle</code>.
</p>
<p>
The difference in results of
<i>T<sub>Out</sub></i> and
<i>X<sub>Out</sub></i>
at the beginning and end of the simulation is because the mass flow rate is zero.
For zero mass flow rate, EnergyPlus assumes steady state condition,
whereas the Modelica model is a dynamic model and hence the properties at the outlet
are equal to the state variables of the model.
</p>
<p>
The EnergyPlus results were generated using the example file <code>DXCoilSystemAuto.idf</code>
from EnergyPlus 22.2. The results were then used to set-up the boundary conditions 
for the model as well as the input signals. To compare the results, 
the Modelica outputs are averaged over <i>3600</i> seconds, and the EnergyPlus 
outputs are used with a zero order delay to avoid the time shift in results.
</p>
<p>
Note that EnergyPlus mass fractions (<code>X</code>) are in mass of water vapor 
per mass of dry air, whereas Modelica uses the total mass as a reference. Also, 
the temperatures in Modelica are in Kelvin whereas they are in Celsius in EnergyPlus.
Hence, the EnergyPlus values are corrected by using the appropriate conversion blocks.
</p>
<p>
The plots compare the outlet temperature and humidity ratio between Modelica and 
EnergyPlus. They also compare the power consumption by the coil compressor as well
as the heat transfer from the airloop.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 2, 2023, by Karthik Devaprasad and Xing Lu:<br/>
First implementation.
</li>
</ul>
</html>"));
end SingleSpeedHeating_OnDemandReverseCycleDefrost;
