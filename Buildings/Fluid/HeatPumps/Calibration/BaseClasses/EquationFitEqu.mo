within Buildings.Fluid.HeatPumps.Calibration.BaseClasses;
block EquationFitEqu

  Modelica.Blocks.Interfaces.RealInput TEvaSet(final unit="K", displayUnit="degC")
    "Set point for leaving chilled water temperature" annotation (Placement(
        transformation(extent={{-124,-112},{-100,-88}}), iconTransformation(
          extent={{-108,-100},{-100,-92}})));
  Modelica.Blocks.Interfaces.RealInput TConSet(final unit="K", displayUnit="degC")
    "Set point for leaving heating water temperature" annotation (Placement(
        transformation(extent={{-124,86},{-100,110}}), iconTransformation(
          extent={{-108,94},{-100,102}})));
  Modelica.Blocks.Interfaces.IntegerInput uMod "Heating mode= 1, Off=0, Cooling mode=-1" annotation (Placement(transformation(extent={{-124,
            -18},{-100,6}}),
        iconTransformation(extent={{-110,-4},{-100,6}})));

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

  parameter Data.EquationFitWaterToWater.Generic_EquationFit per
    "Performance data"
    annotation (choicesAllMatching = true,
                Placement(transformation(extent={{40,60},{60,80}})));

  parameter Modelica.SIunits.HeatFlowRate   QCon_heatflow_nominal=per.QCon_heatflow_nominal
  "Heating load nominal capacity_Heating mode";
  parameter Modelica.SIunits.HeatFlowRate   QEva_heatflow_nominal=per.QEva_heatflow_nominal
  "Cooling load nominal capacity_Cooling mode";
  parameter Modelica.SIunits.VolumeFlowRate VCon_flow_nominal=per.VCon_nominal
  "Heating mode Condenser volume flow rate nominal capacity";
  parameter Modelica.SIunits.MassFlowRate   mCon_flow_nominal= per.mCon_flow_nominal
  "Heating mode Condenser mass flow rate nominal capacity";
  parameter Modelica.SIunits.VolumeFlowRate VEva_flow_nominal=per.VEva_nominal
  "Heating mode Condenser volume flow rate nominal capacity";
  parameter Modelica.SIunits.MassFlowRate   mEva_flow_nominal=per.mEva_flow_nominal
  "Heating mode Evaporator mass flow rate nominal capacity";
  parameter Modelica.SIunits.Power          PCon_nominal_HD= per.PCon_nominal_HD
  "Heating mode Compressor Power nominal capacity";
  parameter Modelica.SIunits.Power          PEva_nominal_CD = per.PEva_nominal_CD
  "Heating mode Compressor Power nominal capacity";
  parameter Modelica.SIunits.Temperature    TRef= per.TRef;
  parameter Modelica.SIunits.HeatFlowRate   Q_flow_small = QCon_heatflow_nominal*1E-9
    "Small value for heat flow rate or power, used to avoid division by zero";

  Modelica.Blocks.Interfaces.RealOutput QCon_flow "Condenser heat flow rate "
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput QEva_flow "Evaporator heat flow rate "
    annotation (Placement(transformation(extent={{100,-48},{120,-28}})));
  Modelica.Blocks.Interfaces.RealOutput P "Compressor power"
    annotation (Placement(transformation(extent={{100,30},{120,50}}), iconTransformation(extent={{100,30},{120,
            50}})));
  Modelica.Blocks.Interfaces.RealInput TConLvg(final unit="K", displayUnit="degC") "Condenser leaving water temperature"
    annotation (Placement(transformation(extent={{-126,66},{-100,92}}), iconTransformation(extent={{-108,76},{-100,84}})));
  Modelica.Blocks.Interfaces.RealInput TConEnt(final unit="K", displayUnit="degC") "Condenser entering water temperature"
    annotation (Placement(transformation(extent={{-126,46},{-100,72}}),iconTransformation(extent={{-108,56},{-100,64}})));
  Modelica.Blocks.Interfaces.RealInput TEvaLvg(final unit="K", displayUnit="degC") "Evaporator leaving water temperature"
    annotation (Placement(transformation(extent={{-126,-76},{-100,-50}}), iconTransformation(extent={{-108,-64},{-100,-56}})));
  Modelica.Blocks.Interfaces.RealInput TEvaEnt(final unit="K", displayUnit="degC") "Evaporator entering water temperature"
    annotation (Placement(transformation(extent={{-126,-94},{-100,-68}}), iconTransformation(extent={{-108,-84},{-100,-76}})));
  Modelica.Blocks.Interfaces.RealInput m1_flow(final unit="kg/s") "Volume 1 massflow rate "
    annotation (Placement(transformation(extent={{-128,16},{-100,44}}), iconTransformation(extent={{-108,36},
            {-100,44}})));
  Modelica.Blocks.Interfaces.RealInput m2_flow(final unit="kg/s") "Volume2 mass flow rate"
    annotation (Placement(transformation(extent={{-126,-34},{-100,-8}}),  iconTransformation(extent={{-108,-44},{-100,-36}})));

  Modelica.Blocks.Interfaces.RealInput QCon_flow_Set(final unit="W", displayUnit="W") "Condenser setpoint heat flow rate"
    annotation (Placement(transformation(extent={{-126,30},{-100,56}}), iconTransformation(extent={{-108,14},{-100,22}})));
  Modelica.Blocks.Interfaces.RealInput QEva_flow_Set(final unit="W", displayUnit="W") "Evaporator setpoint heat flow rate"
    annotation (Placement(transformation(extent={{-126,-54},{-100,-28}}), iconTransformation(extent={{-108,-24},{-100,-16}})));

protected
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

  // Available heating capacihContyQCon_flow_set
      QCon_flow_ava= HLR *(QCon_heatflow_nominal);

      QEva_flow_ava = 0;

 // Heating capacity required to heat water to setpoint

      QCon_flow = Buildings.Utilities.Math.Functions.smoothMin(
        x1 = QCon_flow_Set,
        x2 = QCon_flow_ava,
        deltaX= Q_flow_small/10);

      QEva_flow = -(QCon_flow - P);

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

      QEva_flow=  Buildings.Utilities.Math.Functions.smoothMax(
        x1 = QEva_flow_Set,
        x2 = QEva_flow_ava,
        deltaX= Q_flow_small/10);

      QCon_flow = -QEva_flow + P;

  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          lineThickness=1)}),                                    Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>

The Block includes the mathematical description of the EQUATIONFit method dedicated for<a href=\"Buildings.Fluid.HeatPumps.WatertoWaterEquationFit\">
Buildings.Fluid.HeatPumo.WatertoWaterEquationFit</a>.

</html>"));
end EquationFitEqu;
