within Buildings.Fluid.HeatPumps.BaseClasses;
block EquationFitReversible
  "Equation fit method to compute the performance of the reversable heat pump"
  extends Modelica.Blocks.Icons.Block;

  parameter Data.EquationFitReversible.Generic per
   "Performance data"
    annotation (choicesAllMatching=true, Placement(transformation(extent={{60,72},
          {80,92}})));
  parameter Real scaling_factor
   "Scaling factor for heat pump capacity";

  Modelica.Blocks.Interfaces.IntegerInput uMod
   "Control input signal, cooling mode= -1, off=0, heating mode=+1"
    annotation (Placement(transformation(extent={{-124,-12},{-100,12}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealInput TLoaEnt(
    final unit="K",
    displayUnit="degC")
   "Load entering fluid temperature"
    annotation (Placement(transformation(extent={{-124,18},{-100,42}}),
        iconTransformation(extent={{-120,20},{-100,40}})));
  Modelica.Blocks.Interfaces.RealInput TSouEnt(
    final unit="K",
    displayUnit="degC")
   "Source entering fluid temperature"
    annotation (Placement(transformation(extent={{-124,-52},{-100,-28}}),
        iconTransformation(extent={{-120,-50},{-100,-30}})));

  Modelica.Blocks.Interfaces.RealInput mLoa_flow(final unit="kg/s")
    "Mass flow rate at load side" annotation (Placement(transformation(extent={{-124,48},
            {-100,72}}),          iconTransformation(extent={{-120,50},{-100,70}})));

  Modelica.Blocks.Interfaces.RealInput mSou_flow(final unit="kg/s")
    "Mass flow rate at source side" annotation (Placement(transformation(extent={{-124,
            -92},{-100,-68}}),       iconTransformation(extent={{-120,-90},{
            -100,-70}})));

  Modelica.Blocks.Interfaces.RealInput Q_flow_set(final unit="W")
    "Required heat to meet set point" annotation (Placement(transformation(
          extent={{-124,76},{-100,100}}),iconTransformation(extent={{-120,80},{-100,
            100}})));

  Modelica.Blocks.Interfaces.RealOutput QLoa_flow(final unit="W")
   "Load heat flow rate"
    annotation (Placement(transformation(extent={{100,50},{120,70}}),
        iconTransformation(extent={{100,50},{120,70}})));

  Modelica.Blocks.Interfaces.RealOutput QSou_flow(final unit="W")
   "Source heat flow rate"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}}),
        iconTransformation(extent={{100,-30},{120,-10}})));

  Modelica.Blocks.Interfaces.RealOutput P(final unit="W")
   "Compressor power"
    annotation (Placement(transformation(extent={{100,10},{120,30}}),
        iconTransformation(extent={{100,10},{120,30}})));

  Modelica.Blocks.Interfaces.RealOutput COP(
   final min=0,
   final unit="1")
   "Coefficient of performance, assuming useful heat is at the load side (at Medium 1)"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}}),
        iconTransformation(extent={{100,-70},{120,-50}})));

  Modelica.Units.SI.Efficiency QRel_flow "Thermal load ratio";
  Modelica.Units.SI.Efficiency PRel "Power ratio";
  Modelica.Units.SI.HeatFlowRate Q_flow_ava
    "Heat (or cooling) capacity available";
  Real PLR(min=0, nominal=1, unit="1")
   "Part load ratio";

protected
  parameter Modelica.Units.SI.HeatFlowRate Q_flow_small(min=Modelica.Constants.eps)
     = per.hea.Q_flow*1E-9*scaling_factor
    "Small value for heat flow rate or power, used to avoid division by zero";
  Real xNor[5] "Normalized inlet variables";

initial equation
  assert(per.hea.Q_flow > 0,
   "Parameter QheaLoa_flow_nominal must be larger than zero.");
  assert(per.coo.Q_flow < 0,
   "Parameter QCooLoa_flow_nominal must be lesser than zero.");
  assert(Q_flow_small > 0,
   "Parameter Q_flow_small must be larger than zero.");

equation
  if (uMod == 0) then
    xNor=fill(0, 5);
  elseif (uMod == -1) then
    xNor={ 1,
           TLoaEnt/per.coo.TRefLoa,
           TSouEnt/per.coo.TRefSou,
           mLoa_flow/(per.coo.mLoa_flow*scaling_factor),
           mSou_flow/(per.coo.mSou_flow*scaling_factor)};
  else // uMod == +1
      xNor={ 1,
           TLoaEnt/per.hea.TRefLoa,
           TSouEnt/per.hea.TRefSou,
           mLoa_flow/(per.hea.mLoa_flow*scaling_factor),
           mSou_flow/(per.hea.mSou_flow*scaling_factor)};

  end if;

  if (uMod==1) then
    QRel_flow = sum(per.hea.coeQ .* xNor);
    Q_flow_ava = QRel_flow*per.hea.Q_flow*scaling_factor;
    QLoa_flow   =Buildings.Utilities.Math.Functions.smoothMin(
      x1=Q_flow_set,
      x2=Q_flow_ava,
      deltaX=Q_flow_small);
    PLR = QLoa_flow / Q_flow_ava;
    PRel =  sum(per.hea.coeP .* xNor);
    P = PLR*PRel*per.hea.P*scaling_factor;
    QSou_flow = -(QLoa_flow -P);
    COP = QLoa_flow/(P+Q_flow_small);
  elseif (uMod==-1) then
    QRel_flow  = sum(per.coo.coeQ .* xNor);
    Q_flow_ava = QRel_flow*per.coo.Q_flow*scaling_factor;
    QLoa_flow =Buildings.Utilities.Math.Functions.smoothMax(
      x1=Q_flow_set,
      x2=Q_flow_ava,
      deltaX=Q_flow_small);
    PLR = QLoa_flow / Q_flow_ava;
    PRel  = sum(per.coo.coeP .* xNor);
    P = PLR*PRel*per.coo.P*scaling_factor;
    QSou_flow = -QLoa_flow + P;
    COP = -QLoa_flow/(P+Q_flow_small);
  else
    QRel_flow=0;
    PRel = 0;
    P = 0;
    Q_flow_ava = 0;
    QLoa_flow = 0;
    QSou_flow = 0;
    PLR=0;
    COP = 0;
  end if;
annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
           Diagram(coordinateSystem(preserveAspectRatio=false)),
  defaultComponentName="equFit",
  Documentation(info="<html>
<p>
Block that implements the equation fit method for the reverse heat pump model
<a href=\"modelica://Buildings.Fluid.HeatPumps.EquationFitReversible\">
Buildings.Fluid.HeatPumps.EquationFitReversible</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 16, 2019 by Michael Wetter:<br/>
Refactored implementation.
</li>
<li>
May 19, 2019, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end EquationFitReversible;
