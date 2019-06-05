within Buildings.Fluid.HeatPumps;
model EquationFitWaterToWater "Water source heat pump_Equation Fit"

  extends Buildings.Fluid.Interfaces.FourPortHeatMassExchanger(
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    show_T=true,
   T1_start = 273.15+25,
   T2_start = 273.15+5,
   m1_flow_nominal= mCon_flow_nominal,
   m2_flow_nominal= mEva_flow_nominal,
    redeclare Buildings.Fluid.MixingVolumes.MixingVolume vol2(
      V=m2_flow_nominal*tau2/rho2_nominal,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      nPorts=2,
    final prescribedHeatFlowRate=true),
    vol1(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      V=m1_flow_nominal*tau1/rho1_nominal,
      nPorts=2,
    final prescribedHeatFlowRate=true));

  Modelica.Blocks.Interfaces.RealInput TEvaSet(final unit="K", displayUnit="degC")
    "Set point for leaving chilled water temperature" annotation (Placement(
        transformation(extent={{-140,-110},{-100,-70}}), iconTransformation(
          extent={{-140,-110},{-100,-70}})));
  Modelica.Blocks.Interfaces.RealInput TConSet(final unit="K", displayUnit="degC")
    "Set point for leaving heating water temperature" annotation (Placement(
        transformation(extent={{-140,70},{-100,110}}), iconTransformation(
          extent={{-140,70},{-100,110}})));
  Modelica.Blocks.Interfaces.IntegerInput uMod "Heating mode= 1, Off=0, Cooling mode=-1" annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Modelica.SIunits.Efficiency HLR
    "Heating load ratio";
  Modelica.SIunits.Efficiency CLR
    "Cooling load ratio";
  Modelica.SIunits.Efficiency P_HD
    "Power Ratio in heating dominanat mode";
  Modelica.SIunits.Efficiency P_CD
    "Power Ratio in cooling dominant mode";
  Modelica.SIunits.HeatFlowRate  QCon_flow
  "Condenser heatflow input";
  Modelica.SIunits.HeatFlowRate  QEva_flow
  "Evaporator heatflow input";
  Modelica.SIunits.Temperature   TEvaLvg
  "Evaporator leaving water temperature";
  Modelica.SIunits.Temperature   TEvaEnt
  "Evaporator entering water temperature";
  Modelica.SIunits.Temperature   TConLvg
  "Condenser leaving water temperature";
  Modelica.SIunits.Temperature   TConEnt
  "Condenser entering water temperature";
  Modelica.SIunits.Power         P
  "HeatPump Compressor Power";
  Modelica.SIunits.HeatFlowRate QCon_flow_ava
  "Heating capacity available at the condender";
  Modelica.SIunits.HeatFlowRate QEva_flow_ava
  "Cooling capacity available at the Evaporator";
  Modelica.SIunits.SpecificEnthalpy hSet_Con
  "Enthalpy setpoint for heating water";
  Modelica.SIunits.SpecificEnthalpy hSet_Eva
  "Enthalpy setpoint for cooling water";
  Modelica.SIunits.SpecificEnthalpy hCon
  "Enthalpy value for heating water";
  Modelica.SIunits.SpecificEnthalpy hEva
  "Enthalpy value for cooling water";
  Modelica.SIunits.HeatFlowRate QCon_flow_set
  "Heating capacity required to heat to set point temperature";
  Modelica.SIunits.HeatFlowRate QEva_flow_set
  "Cooling capacity required to cool to set point temperature";

  final parameter Modelica.SIunits.HeatFlowRate   QCon_heatflow_nominal=per.QCon_heatflow_nominal
  "Heating load nominal capacity_Heating mode";
  final parameter Modelica.SIunits.HeatFlowRate   QEva_heatflow_nominal=per.QEva_heatflow_nominal
  "Cooling load nominal capacity_Cooling mode";
  final parameter Modelica.SIunits.VolumeFlowRate VCon_flow_nominal=per.VCon_nominal
  "Heating mode Condenser volume flow rate nominal capacity";
  final parameter Modelica.SIunits.MassFlowRate   mCon_flow_nominal= per.mCon_flow_nominal
  "Heating mode Condenser mass flow rate nominal capacity";
  final parameter Modelica.SIunits.VolumeFlowRate VEva_flow_nominal=per.VEva_nominal
  "Heating mode Condenser volume flow rate nominal capacity";
  final parameter Modelica.SIunits.MassFlowRate   mEva_flow_nominal=per.mEva_flow_nominal
  "Heating mode Evaporator mass flow rate nominal capacity";
  final parameter Modelica.SIunits.Power          PCon_nominal_HD= per.PCon_nominal_HD
  "Heating mode Compressor Power nominal capacity";
  final parameter Modelica.SIunits.Power          PEva_nominal_CD = per.PEva_nominal_CD
  "Heating mode Compressor Power nominal capacity";
  final parameter Modelica.SIunits.Temperature    TRef= per.TRef;
  final parameter Modelica.SIunits.HeatFlowRate   Q_flow_small = QCon_heatflow_nominal*1E-9
    "Small value for heat flow rate or power, used to avoid division by zero";

  parameter
    Buildings.Fluid.HeatPumps.Data.EquationFitWaterToWater.Generic_EquationFit
    per annotation (choicesAllMatching=true, Placement(transformation(extent={{
            48,12},{80,44}})));

protected
  Modelica.Blocks.Sources.RealExpression QCon_flow_in( final y=QCon_flow)
  "Condenser heat flow rate"
    annotation (Placement(transformation(extent={{-82,36},{-62,56}})));

  Modelica.Blocks.Sources.RealExpression QEva_flow_in( final y=QEva_flow)
  "Evaorator heat flow rate"
    annotation (Placement(transformation(extent={{-82,-50},{-62,-30}})));

  HeatTransfer.Sources.PrescribedHeatFlow preHeaFloCon
  "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-39,24},{-19,44}})));

  HeatTransfer.Sources.PrescribedHeatFlow preHeaFloEva
  "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-43,-30},{-23,-10}})));

 // Load and power coefficients matrices
    Real A1[5];
    Real x1[5];
    Real A2[5];
    Real x2[5];

initial equation
   assert(QCon_heatflow_nominal> 0,"Parameter QCon_heatflow_nominal must be greater than zero.");
   assert(QEva_heatflow_nominal< 0,"Parameter QEva_heatflow_nominal must be greater than zero.");
   assert(Q_flow_small > 0,"Parameter Q_flow_small must be larger than zero.");

equation
  // Condenser temperatures
  TConLvg = vol1.heatPort.T;
  TConEnt= Medium1.temperature(Medium1.setState_phX(port_a1.p, inStream(port_a1.h_outflow)));
  // Evaporator temperatures
  TEvaEnt= Medium2.temperature(Medium2.setState_phX(port_a2.p, inStream(port_a2.h_outflow)));
  TEvaLvg= vol2.heatPort.T;

  if (uMod==1) then
    A1=per.HLRC;
    x1={1,TConEnt/TRef,TEvaEnt/TRef,
      m1_flow/mCon_flow_nominal,m2_flow/mEva_flow_nominal};

    A2= per.P_HDC;
    x2={1,TConEnt/TRef,TEvaEnt/TRef,
       m1_flow/mCon_flow_nominal,m2_flow/mEva_flow_nominal};

    HLR  = sum( A1.*x1);
    CLR = 0;
    P_HD = sum( A2.*x2);
    P_CD = 0;

  // Compressor power
    P = P_HD * (PCon_nominal_HD);

  // Available heating capacity
    QCon_flow_ava= HLR *(QCon_heatflow_nominal);

    QEva_flow_ava = 0;

 // Heating capacity required to heat water to setpoint
    QCon_flow_set = Buildings.Utilities.Math.Functions.smoothMax(
      x1 = (m1_flow)*(hSet_Con-inStream(port_a1.h_outflow)),
      x2 = Q_flow_small,
      deltaX = Q_flow_small/10);
    QEva_flow_set = 0;

 // Condenser water enthalpy setpoint
    hSet_Con = Medium1.specificEnthalpy_pTX(
              p=port_b1.p,
      T=TConSet,
      X=cat(1,
        port_b1.Xi_outflow,
        {1 - sum(port_b1.Xi_outflow)}));

   hSet_Eva=0;
   hCon=0;

   hEva = Medium2.specificEnthalpy_pTX(
           p=port_b2.p,
           T=TEvaLvg,
           X=cat(1, port_b2.Xi_outflow, {1-sum(port_b2.Xi_outflow)}));

   QCon_flow = Buildings.Utilities.Math.Functions.smoothMin(
      x1 = QCon_flow_set,
      x2 = QCon_flow_ava,
      deltaX= Q_flow_small/10);

   QEva_flow = -(QCon_flow -P);

//***********************************************************************
  elseif (uMod==0) then

    A1={0,0,0,0,0};
    x1={0,0,0,0,0};
    A2={0,0,0,0,0};
    x2={0,0,0,0,0};
    HLR= 0;
    CLR=0;
    P_HD =0;
    P_CD = 0;
    P = 0;
    QCon_flow_ava = 0;
    QEva_flow_ava = 0;
    QCon_flow_set = 0;
    QEva_flow_set = 0;
    hSet_Con  = 0;
    hEva  = 0;
    hCon  = 0;
    hSet_Eva  = 0;
    QCon_flow = 0;
    QEva_flow = 0;

//***********************************************************
  else

 //-----------------------------------------------------
    A1= per.CLRC;
    x1={1,TConEnt/TRef,TEvaEnt/TRef,
       m1_flow/mCon_flow_nominal,m2_flow/mEva_flow_nominal};

    A2= per.P_CDC;
    x2={1,TConEnt/TRef,TEvaEnt/TRef,
       m1_flow/mCon_flow_nominal,m2_flow/mEva_flow_nominal};
 //---------------------------------------------------------
    HLR = 0;
    CLR  = sum(A1.*x1);
    P_HD = 0;
    P_CD = sum(A2.*x2);
    P = P_CD * (PEva_nominal_CD);
 //---------------------------------------------------------
    QCon_flow_ava = 0;
    QEva_flow_ava = CLR* (QEva_heatflow_nominal);
 //---------------------------------------------------------
 // Cooling capacity required to cool water to setpoint
    QCon_flow_set = 0;
    QEva_flow_set = Buildings.Utilities.Math.Functions.smoothMin(
        x1 = (m2_flow)*(hSet_Eva-inStream(port_a2.h_outflow)),
        x2= -Q_flow_small,
        deltaX=Q_flow_small/100);

 // Evaporator water enthalpy setpoint
    hSet_Eva = Medium2.specificEnthalpy_pTX(
                 p=port_b2.p,
                 T=TEvaSet,
                 X=cat(1,port_b2.Xi_outflow,{1 - sum(port_b2.Xi_outflow)}));
    hSet_Con=0;
    hEva=0;

    hCon = Medium1.specificEnthalpy_pTX(
           p=port_b1.p,
           T=TConLvg,
           X=cat(1, port_b1.Xi_outflow, {1-sum(port_b1.Xi_outflow)}));

    QEva_flow= Buildings.Utilities.Math.Functions.smoothMax(
        x1 = QEva_flow_set,
        x2 = QEva_flow_ava,
        deltaX= Q_flow_small/10);

    QCon_flow = -QEva_flow + P;

  end if;

//--------------------------------------------------------------------------

  connect(preHeaFloCon.port,vol1.heatPort)
  annotation (Line(points={{-19,34},{-16,34},{-16,60},{-10,60}}, color={191,0,0}));

  connect(QCon_flow_in.y, preHeaFloCon.Q_flow)
    annotation (Line(points={{-61,46},{-52,46},{-52,34},{-39,34}}, color={0,0,127}));
  connect(QEva_flow_in.y, preHeaFloEva.Q_flow)
    annotation (Line(points={{-61,-40},{-52,-40},{-52,-20},{-43,-20}}, color={0,0,127}));
  connect(preHeaFloEva.port, vol2.heatPort)
    annotation (Line(points={{-23,-20},{20,-20},{20,-60},{12,-60}}, color={191,0,0}));
    annotation (Placement(transformation(extent={{-78,24},{-58,44}})),
                Placement(transformation(extent={{-10,-50},{-50,-30}})),
                 Placement(transformation(extent={{-86,-50},{-66,-30}})),
                Placement(transformation(extent={{-80,-50},{-60,-30}})),
                Placement(transformation(extent={{-78,24},{-58,44}})),
                 Dialog(group="Nominal condition"),
               Dialog(group="Nominal condition"),
              Dialog(group="Nominal condition"),
              Dialog(group="Nominal condition"),
              Dialog(group="Nominal condition"),
              Dialog(group="Nominal condition"),
              Dialog(group="Nominal condition"),
              Dialog(group="Nominal condition"),
              Dialog(group="Nominal condition"),
              Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},
            {100,100}}),       graphics={
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Rectangle(
          extent={{-56,68},{58,50}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,-52},{58,-70}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-103,64},{98,54}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,54},{98,64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-101,-56},{100,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-66},{0,-56}},
          lineColor={0,0,127},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,0},{-52,-12},{-32,-12},{-42,0}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Polygon(
          points={{-42,0},{-52,10},{-32,10},{-42,0}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Rectangle(
          extent={{-44,50},{-40,10}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,-12},{-40,-52}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{38,50},{42,-52}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{18,22},{62,-20}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Polygon(
          points={{40,22},{22,-10},{58,-10},{40,22}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{0,-70},{0,-90},{-100,-90}},color={0,0,255}),
        Line(points={{0,68},{0,90},{-100,90}},   color={0,0,255})}),
    defaultComponentName="heaPum",
    Documentation(info="<html>
    
    Model for a water to water heat pump using the equation fit model as described
in the EnergyPlus HeatPump: Waterto Water equationfit model and based on (J.Hui 2002, S.Arun. 2004 and C.Tang 2004). 
<p>
The model uses four non-dimensional equations or curves to predict the heatpump performance in either cooling or heating modes.
The methodology involved using the generalized least square method to create a set of performance 
coefficients (A1 to A10) and (B1 to B10) from the catalog data at indicated reference conditions. Then the respective coefficients
and indicated reference conditions are used in the model to simulate the heat pump performance.
The variables includes load side inlet temperature,source side inlet temperature,
load side water flow rate and source side water flow rate. Source and load are identified based on the thermal dominated mode,
for ex. in case of heating dominated mode, the source is the evaporator and load is the condenser.
<P>
The heating and cooling coefficients are stored in the data record per and are available from <a href=\"Buildings.Fluid.HeatPumo.Data.WatertoWaterEquationFit\"> 
Buildings.Fluid.HeatPumo.Data.WatertoWaterEquationFit</a>.

<p>
<h4>Implementation</h4>
This model uses four functions to predict capacity and power consumption for heating and cooling dominated modes:
<p>
1. The heating dominated mode: 
  <p>
  <p align=\"left\" style=\"font-style:italic;\">
(Q&#775;<sub>Con</sub>)/(Q&#775;<sub>Con,nominal</sub>) = A<sub>1</sub>+ A<sub>2</sub>[T<sub>Con,Ent</sub>/T<sub>Con,nominal</sub>]+ 
A<sub>3</sub>[T<sub>Eva,Ent</sub>/T<sub>Eva,nominal</sub>]+ A<sub>4</sub>[V&#775;<sub>Con,Ent</sub>/V&#775;<sub>Con,nominal</sub>]+
+ A<sub>5</sub>[V&#775;<sub>Eva,Ent</sub>/V&#775;<sub>Eva,nominal</sub>]
</p>
<p>
  <p align=\"left\" style=\"font-style:italic;\">
(Power<sub>Con</sub>)/(Power<sub>Con,nominal</sub>) = B<sub>1</sub>+ B<sub>2</sub>[T<sub>Con,Ent</sub>/T<sub>Con,nominal</sub>]+ 
B<sub>3</sub>[T<sub>Eva,Ent</sub>/T<sub>Eva,nominal</sub>]+ B<sub>4</sub>[V&#775;<sub>Con,Ent</sub>/V&#775;<sub>Con,nominal</sub>]+
+ B<sub>5</sub>[V&#775;<sub>Eva,Ent</sub>/V&#775;<sub>Eva,nominal</sub>]
  </p>
<p align=\"center\" style=\"font-style:italic;\">

<p>
2. The cooling dominated mode:
  <p>
  <p align=\"left\" style=\"font-style:italic;\">
(Q&#775;<sub>Eva</sub>)/(Q&#775;<sub>Eva,nominal</sub>) = A<sub>6</sub>+ A<sub>7</sub>[T<sub>Con,Ent</sub>/T<sub>Con,nominal</sub>]+ 
A<sub>8</sub>[T<sub>Eva,Ent</sub>/T<sub>Eva,nominal</sub>]+ A<sub>9</sub>[V&#775;<sub>Con,Ent</sub>/V&#775;<sub>Con,nominal</sub>]+
+ A<sub>10</sub>[V&#775;<sub>Eva,Ent</sub>/V&#775;<sub>Eva,nominal</sub>]
  </p>

  <p align=\"left\" style=\"font-style:italic;\">
(Power<sub>Eva</sub>)/(Power<sub>Eva,nominal</sub>) = B<sub>6</sub>+ B<sub>7</sub>[T<sub>Con,Ent</sub>/T<sub>Con,nominal</sub>]+ 
B<sub>8</sub>[T<sub>Eva,Ent</sub>/T<sub>Eva,nominal</sub>]+ B<sub>9</sub>[V&#775;<sub>Con,Ent</sub>/V&#775;<sub>Con,nominal</sub>]+
+ B<sub>10</sub>[V&#775;<sub>Eva,Ent</sub>/V&#775;<sub>Eva,nominal</sub>]
  </p>
  <p align=\"center\" style=\"font-style:italic;\">

<p>
For these four equations, the inlet conditions or variables are divided by the reference conditions. This formulation allows the coefficients to fall into smaller range of values. moreover, the value of the coefficient 
indirectly represents the sensitivity of the output to that particular inlet variable.
<p>
The model takes as an input the set point for either the leaving  water temperature for the 
condenser or evaporator which is met if the heatpump has sufficient capacity. In addition to the integer input which identifies the heat pump operational mode,1 for heating dominated mode,
-1 cooling dominated mode and 0 shut off the system.
<p>
The electric power only includes the power for the compressor, but not any power for pumps or fans



<h4>References</h4>
<p>
C.C Tang
 <i>
Equation fit based models of water source heat pumps.
  </i>
Master Thesis. Oklahoma State University. Stillwater, Oklahoma, USA. 2005.
  </p>
  </html>", revisions="<html>
<ul>
<li>
May 3, 2019, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end EquationFitWaterToWater;
