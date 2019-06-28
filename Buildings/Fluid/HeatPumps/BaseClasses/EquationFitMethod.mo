within Buildings.Fluid.HeatPumps.BaseClasses;
block EquationFitMethod "EquationFit method to predict heatpump performance"
  extends ModelicaReference.Icons.Package;

    parameter Data.EquationFitWaterToWater.Generic_EquationFit per
      "Performance data"
       annotation (choicesAllMatching = true,
                Placement(transformation(extent={{78,80},{98,100}})));
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
    final parameter Modelica.SIunits.Temperature    TRef= per.TRef
      "Reference temperature used to normalize the inlet temperature variables";
    final parameter Modelica.SIunits.HeatFlowRate   Q_flow_small = QCon_heatflow_nominal*1E-9
      "Small value for heat flow rate or power, used to avoid division by zero";

    Modelica.SIunits.Efficiency HLR
      "Heating load ratio";
    Modelica.SIunits.Efficiency CLR
      "Cooling load ratio";
    Modelica.SIunits.Efficiency P_HD
      "Power Ratio in heating dominanat mode";
    Modelica.SIunits.Efficiency P_CD
      "Power Ratio in cooling dominant mode";
    Modelica.SIunits.HeatFlowRate QCon_flow_ava
      "Heating capacity available at the condender";
    Modelica.SIunits.HeatFlowRate QEva_flow_ava
      "Cooling capacity available at the Evaporator";

    Modelica.Blocks.Interfaces.RealInput TEvaSet(final unit="K", displayUnit="degC")
      "Set point for leaving chilled water temperature"
       annotation (Placement(
        transformation(extent={{-124,-112},{-100,-88}}), iconTransformation(
          extent={{-118,-108},{-100,-90}})));
    Modelica.Blocks.Interfaces.RealInput TConSet(final unit="K", displayUnit="degC")
      "Set point for leaving heating water temperature"
       annotation (Placement(
        transformation(extent={{-122,88},{-100,110}}), iconTransformation(
          extent={{-120,90},{-100,110}})));
    Modelica.Blocks.Interfaces.IntegerInput uMod
      "Heating mode= 1, Off=0, Cooling mode=-1"
       annotation (Placement(transformation(extent={{-124,
            -12},{-100,12}}),
        iconTransformation(extent={{-118,-10},{-100,8}})));
    Modelica.Blocks.Interfaces.RealOutput QCon(final unit="W", displayUnit="W")
      "Condenser heat flow rate "
       annotation (Placement(transformation(extent={{100,
            30},{120,50}}), iconTransformation(extent={{100,30},{120,50}})));
    Modelica.Blocks.Interfaces.RealOutput QEva(final unit="W", displayUnit="W")
      "Evaporator heat flow rate "
       annotation (Placement(transformation(extent={{100,
            -48},{120,-28}}), iconTransformation(extent={{100,-50},{120,-30}})));
    Modelica.Blocks.Interfaces.RealOutput P(final unit="W", displayUnit="W")
      "Compressor power"
       annotation (Placement(transformation(extent={{100,-10},{120,10}}),iconTransformation(extent={{100,-10},
            {120,10}})));
    Modelica.Blocks.Interfaces.RealInput TConLvg(final unit="K", displayUnit="degC")
      "Condenser leaving water temperature"
       annotation (Placement(transformation(extent={{-122,68},{-100,90}}), iconTransformation(extent={{-120,70},
            {-100,90}})));
    Modelica.Blocks.Interfaces.RealInput TConEnt(final unit="K", displayUnit="degC")
      "Condenser entering water temperature"
       annotation (Placement(transformation(extent={{-124,48},{-100,72}}),iconTransformation(extent={{-120,50},
            {-100,70}})));
    Modelica.Blocks.Interfaces.RealInput TEvaLvg(final unit="K", displayUnit="degC")
      "Evaporator leaving water temperature"
       annotation (Placement(transformation(extent={{-124,-72},{-100,-48}}), iconTransformation(extent={{-118,
            -70},{-100,-52}})));
    Modelica.Blocks.Interfaces.RealInput TEvaEnt(final unit="K", displayUnit="degC")
      "Evaporator entering water temperature"
       annotation (Placement(transformation(extent={{-124,-92},{-100,-68}}), iconTransformation(extent={{-118,
            -88},{-100,-70}})));
    Modelica.Blocks.Interfaces.RealInput m1_flow(final unit="kg/s")
      "Volume 1 massflow rate "
       annotation (Placement(transformation(extent={{-124,8},{-100,32}}),  iconTransformation(extent={{-120,30},
            {-100,50}})));
    Modelica.Blocks.Interfaces.RealInput m2_flow(final unit="kg/s")
      "Volume2 mass flow rate"
       annotation (Placement(transformation(extent={{-124,-32},{-100,-8}}),  iconTransformation(extent={{-118,
            -48},{-100,-30}})));
    Modelica.Blocks.Interfaces.RealInput QConFloSet(final unit="W", displayUnit="W")
       "Condenser setpoint heat flow rate"
        annotation (Placement(transformation(
          extent={{-124,28},{-100,52}}), iconTransformation(extent={{-120,10},{-100,
            30}})));
    Modelica.Blocks.Interfaces.RealInput QEvaFloSet(final unit="W", displayUnit="W")
      "Evaporator setpoint heat flow rate"
       annotation (Placement(transformation(
          extent={{-124,-52},{-100,-28}}), iconTransformation(extent={{-118,-30},
            {-100,-12}})));

protected
    Real A1[5] "Thermal load ratio coefficients";
    Real x1[5] "normalized inlet variables";
    Real A2[5] "Compressor power ratio coefficients";
    Real x2[5] "normalized inlet variables";

initial equation
   assert(QCon_heatflow_nominal> 0,
   "Parameter QCon_heatflow_nominal must be larger than zero.");
   assert(QEva_heatflow_nominal< 0,
   "Parameter QEva_heatflow_nominal must be lesser than zero.");
   assert(Q_flow_small > 0,
   "Parameter Q_flow_small must be larger than zero.");

equation
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
      QCon_flow_ava= HLR *(QCon_heatflow_nominal);
      QEva_flow_ava = 0;

      QCon = Buildings.Utilities.Math.Functions.smoothMin(
      x1=QConFloSet,
      x2=QCon_flow_ava,
      deltaX=Q_flow_small/10);

      P = P_HD * (PCon_nominal_HD);
      QEva = -(QCon - P);

    elseif (uMod==-1) then

      A1= per.CLRC;
      x1={1,TConEnt/TRef,TEvaEnt/TRef,
      m1_flow/mCon_flow_nominal,m2_flow/mEva_flow_nominal};

      A2= per.P_CDC;
      x2={1,TConEnt/TRef,TEvaEnt/TRef,
      m1_flow/mCon_flow_nominal,m2_flow/mEva_flow_nominal};

      HLR = 0;
      CLR  = sum(A1.*x1);
      P_HD = 0;
      P_CD = sum(A2.*x2);
      QCon_flow_ava = 0;
      QEva_flow_ava = CLR* (QEva_heatflow_nominal);

      QEva = Buildings.Utilities.Math.Functions.smoothMax(
      x1=QEvaFloSet,
      x2=QEva_flow_ava,
      deltaX=Q_flow_small/10);

      P = P_CD * (PEva_nominal_CD);
      QCon = -QEva + P;

    else

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
      QCon = 0;
      QEva = 0;

    end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
              Text(extent={{-152,100},{148,140}},lineColor={0,0,255},textString
            =    "%name")}),
              Diagram(coordinateSystem(preserveAspectRatio=false)),
  defaultComponentName="equFit",
  Documentation(info="<html>
<p>
The Block includes the description of the equation fit method dedicated for
<a href=\"Buildings.Fluid.HeatPumps.EquationFitWaterToWater\">
Buildings.Fluid.HeatPumps.EquationFitWaterToWater</a>.
</p>
<p>
The block uses four functions to predict capacity and power consumption for heating mode
<code>uMod</code>=+1 and cooling mode <code>uMod</code>=-1:
</p>
<ul>
<li>
The heating mode when <code>uMod</code>=+1:
<p align=\"left\" style=\"font-style:italic;\">
Q&#775;<sub>Con</sub>/Q&#775;<sub>Con,nominal</sub> = A<sub>1</sub>+ A<sub>2</sub> T<sub>Con,Ent</sub>/T<sub>Con,nominal</sub>+
A<sub>3</sub> T<sub>Eva,Ent</sub>/T<sub>Eva,nominal</sub>+ A<sub>4</sub> V&#775;<sub>Con,Ent</sub>/V&#775;<sub>Con,nominal</sub>+
+ A<sub>5</sub> V&#775;<sub>Eva,Ent</sub>/V&#775;<sub>Eva,nominal</sub>

<p align=\"left\" style=\"font-style:italic;\">
Power<sub>Con</sub>/Power<sub>Con,nominal</sub>= B<sub>1</sub>+ B<sub>2</sub> T<sub>Con,Ent</sub>/T<sub>Con,nominal</sub>+
B<sub>3</sub>.T<sub>Eva,Ent</sub>/T<sub>Eva,nominal</sub>+ B<sub>4</sub> V&#775;<sub>Con,Ent</sub>/V&#775;<sub>Con,nominal</sub>+
+ B<sub>5</sub> V&#775;<sub>Eva,Ent</sub>/V&#775;<sub>Eva,nominal</sub>
</li>
</ul>
<p>
where the coefficients <i>A<sub>1</sub> to A<sub>5</sub> </i> and  <i>B<sub>1</sub> to B<sub>5</sub> </i>
are stored in the data record <code>per</code> at <a href=\"Buildings.Fluid.HeatPumps.Data.EquationFitWaterToWater\">
Buildings.Fluid.HeatPumps.Data.EquationFitWaterToWater</a>.
</p>

<ul>
<li>
The cooling mode when <code>uMod</code>=-1:
<p align=\"left\" style=\"font-style:italic;\">
Q&#775;<sub>Eva</sub>/Q&#775;<sub>Eva,nominal</sub> = A<sub>6</sub>+ A<sub>7</sub> T<sub>Con,Ent</sub>/T<sub>Con,nominal</sub>+
A<sub>8</sub> T<sub>Eva,Ent</sub>/T<sub>Eva,nominal</sub>+ A<sub>9</sub> V&#775;<sub>Con,Ent</sub>/V&#775;<sub>Con,nominal</sub>+
+ A<sub>10</sub> V&#775;<sub>Eva,Ent</sub>/V&#775;<sub>Eva,nominal</sub>

<p align=\"left\" style=\"font-style:italic;\">
 Power<sub>Eva</sub>/Power<sub>Eva,nominal</sub> = B<sub>6</sub>+ B<sub>7</sub>.T<sub>Con,Ent</sub>/T<sub>Con,nominal</sub>+
 B<sub>8</sub> T<sub>Eva,Ent</sub>/T<sub>Eva,nominal</sub>+ B<sub>9</sub> V&#775;<sub>Con,Ent</sub>/V&#775;<sub>Con,nominal</sub>+
 + B<sub>10</sub> V&#775;<sub>Eva,Ent</sub>/V&#775;<sub>Eva,nominal</sub>
</li>
</ul>
<p>
where the coefficients <i>A<sub>6</sub> to A<sub>10</sub> </i> and  <i>B<sub>6</sub> to B<sub>10</sub> </i>
are stored in the data record <code>per</code> at <a href=\"Buildings.Fluid.HeatPumps.Data.EquationFitWaterToWater\">
Buildings.Fluid.HeatPumps.Data.EquationFitWaterToWater</a>.
</p>

<p>
For these four equations, the inlet conditions or variables are divided by the reference conditions.
This formulation allows the coefficients to fall into smaller range of values. Moreover, the value of the coefficient
indirectly represents the sensitivity of the output to that particular inlet variable.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 19, 2019, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end EquationFitMethod;
