within Districts.Electrical.Interfaces;
partial model PartialLoad
  replaceable package PhaseSystem =
      Districts.Electrical.PhaseSystems.PartialPhaseSystem
       constrainedby Districts.Electrical.PhaseSystems.PartialPhaseSystem
    "Phase system"
    annotation (choicesAllMatching=true);
  Modelica.SIunits.Voltage v[:](each start = V_nominal) = terminal.v;
  Modelica.SIunits.Current i[:](each start = P_nominal/V_nominal)= terminal.i;
  Modelica.SIunits.Power S[PhaseSystem.n] = PhaseSystem.phasePowers_vi(v, i)
    "Phase powers";
  Modelica.SIunits.Power P
    "Power of the load (negative if consumed, positive if fed into the electrical grid)";
  parameter Boolean linear = false
    "If =true introduce a linearization in the load"                                                    annotation(evaluate=true,Dialog(group="Modelling assumption"));
  parameter Districts.Electrical.Types.Assumption
                       mode(min=1,max=4) = Districts.Electrical.Types.Assumption.FixedZ_steady_state annotation(evaluate=true,Dialog(group="Modelling assumption"));
  parameter Modelica.SIunits.Power P_nominal(start=0)
    "Nominal power (negative if consumed, positive if generated)"  annotation(evaluate=true,Dialog(group="Nominal conditions",
        enable = mode <> 3));
  parameter Modelica.SIunits.Voltage V_nominal(min=0, start=220)
    "Nominal voltage (V_nominal >= 0)"  annotation(evaluate=true, Dialog(group="Nominal conditions", enable = (mode==2 or linear)));
  Modelica.Blocks.Interfaces.RealInput y if mode==4
    "Fraction of the nominal power consumed"                       annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,0}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,0})));
  Modelica.Blocks.Interfaces.RealInput Pow(unit="W") if mode==3
    "Power consumed"                       annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,0}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,0})));
  replaceable Districts.Electrical.Interfaces.Terminal terminal(redeclare
      package PhaseSystem =
        PhaseSystem) "Generalised terminal"
    annotation (Placement(transformation(extent={{-108,-8},{-92,8}}),
        iconTransformation(extent={{-108,-8},{-92,8}})));
protected
  Modelica.Blocks.Interfaces.RealInput y_
    "Hidden value of the input load for the conditional connector";
  Modelica.Blocks.Interfaces.RealInput Pow_
    "Hidden value of the input power for the conditional connector";
  Real load(min=eps, max=1)
    "Internal representation of control signal, used to avoid singularity";
  constant Real eps = 1E-10
    "Small number used to avoid a singularity if the power is zero";
  constant Real oneEps = 1-eps
    "Small number used to avoid a singularity if the power is zero";
equation
  assert(y_>=0 and y_<=1+eps, "The power load fraction P (input of the model) must be within [0,1]");

  // Connection between the conditional and inner connector
  connect(y,y_);
  connect(Pow,Pow_);

  // If the power is fixed, inner connector value is equal to 1
  if mode==1 or mode==2 then
    y_   = 1;
    Pow_ = P_nominal;
  elseif mode==3 then
    y_ = 1;
  elseif mode==4 then
    Pow_ = 0;
  end if;

  // Value of the load, depending on the type: fixed or variable
  if mode==4 then
    load = eps + oneEps*y_;
  else
    load = 1;
  end if;

  // Power consumption
  if mode==1 or mode==2 then
    P = P_nominal;
  elseif mode==3 then
    if Pow_ >=0 then
      P = - max(eps, Pow_);
    else
      P = - min(-eps, Pow_);
    end if;
  else
    P = P_nominal*load;
  end if;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end PartialLoad;
