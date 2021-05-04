within Buildings.ThermalZones.Detailed.BaseClasses;
model CFDAirHeatMassBalance
  "Heat and mass balance of the air based on computational fluid dynamics"
  extends Buildings.ThermalZones.Detailed.BaseClasses.PartialAirHeatMassBalance;

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);

  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics massDynamics
    "Formulation of mass balance"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  // Initialization
  parameter Medium.AbsolutePressure p_start "Start value of pressure"
    annotation(Dialog(tab = "Initialization"));

  parameter String cfdFilNam "CFD input file name"
    annotation (Dialog(loadSelector(caption="Select CFD input file")));
  parameter Boolean useCFD=true
    "Set to false to deactivate the CFD interface and use instead yFixed as output"
    annotation (Evaluate=true);

  parameter Modelica.SIunits.Time samplePeriod(min=100*Modelica.Constants.eps)
    "Sample period of component" annotation (Dialog(group="Sampling"));

  parameter Boolean haveSensor
    "Flag, true if the model has at least one sensor";
  parameter Integer nSen(min=0)
    "Number of sensors that are connected to CFD output";
  parameter String sensorName[nSen]
    "Names of sensors as declared in the CFD input file";
  parameter String portName[nPorts]
    "Names of fluid ports as declared in the CFD input file";
  parameter Real uSha_fixed[nConExtWin]
    "Constant control signal for the shading device (0: unshaded; 1: fully shaded)";

  CFDExchange cfd(
    final cfdFilNam=cfdFilNam,
    final startTime=startTime,
    final activateInterface=useCFD,
    final samplePeriod=if useCFD then samplePeriod else Modelica.Constants.inf,
    final nWri=kFluIntC_inflow + Medium.nC*nPorts,
    final nRea=kSen + nSen,
    final nSur=nSur,
    final surIde=surIde,
    final haveShade=haveShade,
    final haveSensor=haveSensor,
    final sensorName=sensorName,
    final portName=portName,
    final yFixed=yFixed,
    final nXi=Medium.nXi,
    final nC=Medium.nC,
    rho_start=rho_start,
    nConExtWin=NConExtWin) "Block that exchanges data with the CFD simulation"
    annotation (Placement(transformation(extent={{-40,180},{-20,200}})));

  Modelica.Blocks.Interfaces.RealOutput yCFD[nSen] if haveSensor
    "Sensor for output from CFD"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={180,-250})));

protected
   parameter Modelica.SIunits.Time startTime(fixed=false)
    "First sample time instant.";

  // Values that are used for yFixed
  parameter Real yFixed[kSen + nSen](each fixed=false)
    "Values used for yFixed in CFDExchange";

  parameter Modelica.SIunits.HeatFlowRate Q_flow_fixed[kSurBou + nSurBou]=
    fill(0, kSurBou + nSurBou) "Surface heat flow rate used for yFixed"
    annotation (Dialog(group="Outputs if activateInterface=false"));
  parameter Modelica.SIunits.Temperature TRooAve_fixed=Medium.T_default
    "Average room air temperature used for yFixed"
    annotation (Dialog(group="Outputs if activateInterface=false"));
  parameter Modelica.SIunits.Temperature TSha_fixed[NConExtWin]=
    fill(Medium.T_default, NConExtWin) "Shade temperature used for yFixed"
    annotation (Dialog(group="Outputs if activateInterface=false"));
  parameter Modelica.SIunits.Temperature T_outflow_fixed[nPorts]=
    fill(Medium.T_default, nPorts)
    "Temperature of the fluid that flows into the HVAC system used for yFixed"
    annotation (Dialog(group="Outputs if activateInterface=false"));
  parameter Real Xi_outflow_fixed[nPorts*Medium.nXi](each fixed=false)
    "Species concentration of the fluid that flows into the HVAC system used for yFixed"
    annotation (Dialog(group="Outputs if activateInterface=false"));
  parameter Real C_outflow_fixed[nPorts*Medium.nC](each fixed=false)
    "Trace substances of the fluid that flows into the HVAC system used for yFixed"
    annotation (Dialog(group="Outputs if activateInterface=false"));

   parameter Modelica.SIunits.Density rho_start=Medium.density(
   Medium.setState_pTX(
     T=Medium.T_default,
     p=p_start,
     X=Medium.X_default)) "Density, used to compute fluid mass";

  final parameter CFDSurfaceIdentifier surIde[kSurBou + nSurBou]=
      assignSurfaceIdentifier(
      nConExt=nConExt,
      nConExtWin=nConExtWin,
      nConPar=nConPar,
      nConBou=nConBou,
      nSurBou=nSurBou,
      nSur=nSur,
      haveShade=haveShade,
      nameConExt=datConExt.name,
      AConExt=datConExt.A,
      tilConExt=datConExt.til,
      bouConConExt=datConExt.boundaryCondition,
      nameConExtWin=datConExtWin.name,
      AConExtWin=datConExtWin.AOpa,
      tilConExtWin=datConExtWin.til,
      bouConConExtWin=datConExtWin.boundaryCondition,
      AGla=datConExtWin.AGla,
      AFra=datConExtWin.AFra,
      uSha=uSha_fixed,
      nameConPar=datConPar.name,
      AConPar=datConPar.A,
      tilConPar=datConPar.til,
      bouConConPar=datConPar.boundaryCondition,
      nameConBou=datConBou.name,
      AConBou=datConBou.A,
      tilConBou=datConBou.til,
      bouConConBou=datConBou.boundaryCondition,
      nameSurBou=surBou.name,
      ASurBou=surBou.A,
      tilSurBou=surBou.til,
      bouConSurBou=surBou.boundaryCondition)
    "Names of all surfaces in the order in which their properties are sent to CFD"
    annotation (Evaluate=true);

  // Interfaces between the CFD block and the heat ports of this model
  // Here, we directly access datConExt instead of surIde. The reason is
  // the Dymola thinks that surIde.bouCon is not fixed at translation time
  // and then refuses to use this parameter to conditionally remove connectors
  // in CFDSurfaceInterface.
  CFDSurfaceInterface cfdConExt[NConExt](final bouCon=datConExt[:].boundaryCondition) if
      haveConExt "Interface to heat port of exterior constructions"
    annotation (Placement(transformation(extent={{180,210},{200,230}})));

  CFDSurfaceInterface cfdConExtWin[NConExtWin](final bouCon=datConExtWin[:].boundaryCondition) if
       haveConExtWin
    "Interface to heat port of opaque part of exterior constructions with window"
    annotation (Placement(transformation(extent={{180,170},{200,190}})));

  CFDSurfaceInterface cfdGlaUns[NConExtWin](final bouCon=datConExtWin[:].boundaryCondition) if
       haveConExtWin "Interface to heat port of unshaded part of glass"
    annotation (Placement(transformation(extent={{180,110},{200,130}})));

  CFDSurfaceInterface cfdGlaSha[NConExtWin](final bouCon=datConExtWin[:].boundaryCondition) if
       haveShade "Interface to heat port of shaded part of glass"
    annotation (Placement(transformation(extent={{180,70},{200,90}})));

  CFDSurfaceInterface cfdConExtWinFra[NConExtWin](final bouCon=datConExtWin[:].boundaryCondition) if
       haveConExtWin "Interface to heat port of window frame"
    annotation (Placement(transformation(extent={{180,-10},{200,10}})));

  CFDSurfaceInterface cfdConPar_a[NConPar](final bouCon=datConPar[:].boundaryCondition) if
       haveConPar
    "Interface to heat port of surface a of partition constructions"
    annotation (Placement(transformation(extent={{180,-70},{200,-50}})));

  CFDSurfaceInterface cfdConPar_b[NConPar](final bouCon=datConPar[:].boundaryCondition) if
       haveConPar
    "Interface to heat port of surface b of partition constructions"
    annotation (Placement(transformation(extent={{180,-110},{200,-90}})));

  CFDSurfaceInterface cfdConBou[NConBou](final bouCon=datConBou[:].boundaryCondition) if
       haveConBou
    "Interface to heat port that connects to room-side surface of constructions that expose their other surface to the outside"
    annotation (Placement(transformation(extent={{180,-170},{200,-150}})));

  CFDSurfaceInterface cfdSurBou[NSurBou](final bouCon=surBou[:].boundaryCondition) if
       haveSurBou
    "Interface to heat port of surfaces of models that compute the heat conduction outside of this room"
    annotation (Placement(transformation(extent={{180,-230},{200,-210}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature cfdHeaPorAir
    "Interface to heat port of air node"
    annotation (Placement(transformation(extent={{-140,-10},{-160,10}})));

  CFDFluidInterface fluInt(
    redeclare final package Medium = Medium,
    final massDynamics=massDynamics,
    final nPorts=nPorts,
    final V=V,
    final p_start=p_start,
    rho_start=rho_start) "Fluid interface"
    annotation (Placement(transformation(extent={{10,-198},{-10,-178}})));

  // The following list declares the first index minus 1
  // of the input and output signals to the CFD block.
  // These parameters are then used to loop over the connectors, such
  // as
  //    for i in kConExt+1:kConExt+nConExt loop
  //      ...
  //    end for;
  final parameter Integer kConExt=0
    "Offset used to connect CFD signals to conExt";
  final parameter Integer kConExtWin=kConExt + nConExt
    "Offset used to connect CFD signals to conExtWin";
  final parameter Integer kGlaUns=kConExtWin + nConExtWin
    "Offset used to connect CFD signals to glaUns";
  final parameter Integer kGlaSha=kGlaUns + nConExtWin
    "Offset used to connect CFD signals to glaSha";
  final parameter Integer kConExtWinFra=if haveShade then kGlaSha + nConExtWin
       else kGlaSha "Offset used to connect CFD signals to glaSha";
  final parameter Integer kConPar_a=kConExtWinFra + nConExtWin
    "Offset used to connect CFD signals to conPar_a";
  final parameter Integer kConPar_b=kConPar_a + nConPar
    "Offset used to connect CFD signals to conPar_b";
  final parameter Integer kConBou=kConPar_b + nConPar
    "Offset used to connect CFD signals to conBou";
  final parameter Integer kSurBou=kConBou + nConBou
    "Offset used to connect CFD signals to surBou";
  final parameter Integer kHeaPorAir=kSurBou + nSurBou
    "Offset used to connect CFD output signal to air heat port (to send average temperature from CFD to Modelica)";
  //  final parameter Integer kUSha = kHeaPorAir + 1
  final parameter Integer kUSha=kSurBou + nSurBou
    "Offset used to connect CFD signals to input signal of shade";
  final parameter Integer kQRadAbs_flow=if haveShade then kUSha + nConExtWin
       else kUSha
    "Offset used to connect CFD signals to input signal that contains the radiation absorbed by the shade";
  // Because heaPorAir is only receiving T from CFD, but does not send Q_flow to CFD, there is no '+1' increment
  // for kTSha
  final parameter Integer kTSha=kHeaPorAir + 1
    "Offset used to connect CFD signals to output signal that contains the shade temperature";

  final parameter Integer kQConGai_flow=if haveShade then kQRadAbs_flow +
      nConExtWin else kQRadAbs_flow
    "Offset used to connect CFD signals to input signal for connect convective sensible heat gain";

  final parameter Integer kQLatGai_flow=kQConGai_flow + 1
    "Offset used to connect CFD signals to input signal for connect radiative heat gain";

  final parameter Integer kFluIntP=kQLatGai_flow + 1
    "Offset used to connect CFD signals to input signal for pressure from the fluid ports";

  final parameter Integer kFluIntM_flow=kFluIntP + 1
    "Offset used to connect CFD signals to input signals for mass flow rate from the fluid ports";
  final parameter Integer kFluIntT_inflow=kFluIntM_flow + nPorts
    "Offset used to connect CFD signals to input signals for inflowing temperature from the fluid ports";
  final parameter Integer kFluIntXi_inflow=kFluIntT_inflow + nPorts
    "Offset used to connect CFD signals to input signals for inflowing species concentration from the fluid ports";

  final parameter Integer kFluIntC_inflow=kFluIntXi_inflow + nPorts*Medium.nXi
    "Offset used to connect CFD signals to input signals for inflowing trace substances from the fluid ports";

  // Input signals to fluInt block
  final parameter Integer kFluIntT_outflow=if haveShade then kTSha + nConExtWin
       else kTSha
    "Offset used to connect CFD signals to outgoing temperature for the fluid ports";
  final parameter Integer kFluIntXi_outflow=kFluIntT_outflow + nPorts
    "Offset used to connect CFD signals to outgoing species concentration for the fluid ports";
  final parameter Integer kFluIntC_outflow=kFluIntXi_outflow + nPorts*Medium.nXi
    "Offset used to connect CFD signals to outgoing trace substances for the fluid ports";
  final parameter Integer kSen=kFluIntC_outflow + nPorts*Medium.nC
    "Offset used to connect CFD signals to output sensor";

  final parameter Integer nSur=kSurBou + nSurBou "Number of surfaces";
protected
  function assignSurfaceIdentifier

    input Integer nConExt(min=0) "Number of exterior constructions";
    input Integer nConExtWin(min=0) "Number of window constructions";
    input Integer nConPar(min=0) "Number of partition constructions";
    input Integer nConBou(min=0)
      "Number of constructions that have their outside surface exposed to the boundary of this room";
    input Integer nSurBou(min=0)
      "Number of surface heat transfer models that connect to constructions that are modeled outside of this room";
    input Integer nSur(min=2) "Total number of surfaces";

    input Boolean haveShade
      "Flag, set to true if any of the window in this room has a shade";
    /*
    // Declaration of counters used in the loop.
    // This could be computed (again) in this function, but using it
    // as a function arguments avoids code duplication.
    input Integer kConExt "Offset used to connect CFD signals to conExt";
    input Integer kConExtWin "Offset used to connect CFD signals to conExtWin";
    input Integer kGlaUns "Offset used to connect CFD signals to glaUns";
    input Integer kGlaSha "Offset used to connect CFD signals to glaSha";
    input Integer kConExtWinFra "Offset used to connect CFD signals to glaSha";
    input Integer kConPar_a "Offset used to connect CFD signals to conPar_a";
    input Integer kConPar_b "Offset used to connect CFD signals to conPar_b";
    input Integer kConBou "Offset used to connect CFD signals to conBou";
    input Integer kSurBou "Offset used to connect CFD signals to surBou";
*/
    // Declaration of construction data
    input String nameConExt[nConExt] "Surface name";
    input Modelica.SIunits.Area AConExt[nConExt] "Surface area";
    input Modelica.SIunits.Angle tilConExt[nConExt] "Surface tilt";
    input Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions bouConConExt[nConExt]
      "Boundary condition";

    input String nameConExtWin[nConExtWin] "Surface name";
    input Modelica.SIunits.Area AConExtWin[nConExtWin] "Surface area";
    input Modelica.SIunits.Angle tilConExtWin[nConExtWin] "Surface tilt";
    input Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions bouConConExtWin[
      nConExtWin] "Boundary condition";
    input Modelica.SIunits.Area AGla[nConExtWin] "Surface area";
    input Modelica.SIunits.Area AFra[nConExtWin] "Surface area";
    input Real uSha[nConExtWin] "Shade ratio";
    input String nameConPar[nConPar] "Surface name";
    input Modelica.SIunits.Area AConPar[nConPar] "Surface area";
    input Modelica.SIunits.Angle tilConPar[nConPar] "Surface tilt";
    input Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions bouConConPar[nConPar]
      "Boundary condition";

    input String nameConBou[nConBou] "Surface name";
    input Modelica.SIunits.Area AConBou[nConBou] "Surface area";
    input Modelica.SIunits.Angle tilConBou[nConBou] "Surface tilt";
    input Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions bouConConBou[nConBou]
      "Boundary condition";

    input String nameSurBou[nSurBou] "Surface name";
    input Modelica.SIunits.Area ASurBou[nSurBou] "Surface area";
    input Modelica.SIunits.Angle tilSurBou[nSurBou] "Surface tilt";
    input Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions bouConSurBou[nSurBou]
      "Boundary condition";

    output CFDSurfaceIdentifier id[nSur] "Name of all surfaces";

  algorithm
    id := cat(
        1,
        {CFDSurfaceIdentifier(
          name=nameConExt[i],
          A=AConExt[i],
          til=tilConExt[i],
          bouCon=bouConConExt[i]) for i in 1:nConExt},
        {CFDSurfaceIdentifier(
          name=nameConExtWin[i],
          A=AConExtWin[i],
          til=tilConExtWin[i],
          bouCon=bouConConExtWin[i]) for i in 1:nConExtWin},
        {CFDSurfaceIdentifier(
          name=nameConExtWin[i] + " (glass, unshaded)",
          A=AGla[i]*(1-uSha[i]),
          til=tilConExtWin[i],
          bouCon=bouConConExtWin[i]) for i in 1:nConExtWin},
        {CFDSurfaceIdentifier(
          name=nameConExtWin[i] + " (glass, shaded)",
          A=AGla[i]*uSha[i],
          til=tilConExtWin[i],
          bouCon=bouConConExtWin[i]) for i in 1:(if haveShade then nConExtWin
         else 0)},
        {CFDSurfaceIdentifier(
          name=nameConExtWin[i] + " (frame)",
          A=AFra[i],
          til=tilConExtWin[i],
          bouCon=bouConConExtWin[i]) for i in 1:nConExtWin},
        {CFDSurfaceIdentifier(
          name=nameConPar[i] + " (surface a)",
          A=AConPar[i],
          til=tilConPar[i],
          bouCon=bouConConPar[i]) for i in 1:nConPar},
        {CFDSurfaceIdentifier(
          name=nameConPar[i] + " (surface b)",
          A=AConPar[i],
          til=tilConPar[i] + Modelica.Constants.pi/180,
          bouCon=bouConConPar[i]) for i in 1:nConPar},
        {CFDSurfaceIdentifier(
          name=nameConBou[i],
          A=AConBou[i],
          til=tilConBou[i],
          bouCon=bouConConBou[i]) for i in 1:nConBou},
        {CFDSurfaceIdentifier(
          name=nameSurBou[i],
          A=ASurBou[i],
          til=tilSurBou[i],
          bouCon=bouConSurBou[i]) for i in 1:nSurBou});
  end assignSurfaceIdentifier;

public
  Modelica.Blocks.Math.Add QTotCon_flow
    "Total sensible convective heat flow rate added to the room"
    annotation (Placement(transformation(extent={{-180,-60},{-160,-40}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor senHeaFlo
    "Sensor for heat flow added through the port heaPorAir"
    annotation (Placement(transformation(extent={{-210,-10},{-190,10}})));
  to_W QTotCon_flow_W
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));
initial equation
   startTime = time;

  for i in 1:nPorts loop
    for j in 1:Medium.nXi loop
      Xi_outflow_fixed[(i - 1)*Medium.nXi + j] = Medium.X_default[j];
    end for;
  end for;

  for i in 1:nPorts loop
    for j in 1:Medium.nC loop
      C_outflow_fixed[(i - 1)*Medium.nC + j] = 0;
    end for;
  end for;

  // Assignment of yFixed
  for i in 1:kSurBou + nSurBou loop
    yFixed[i] = Q_flow_fixed[i];
  end for;
  yFixed[kHeaPorAir + 1] = TRooAve_fixed;
  if haveShade then
    for i in 1:nConExtWin loop
      yFixed[kTSha + i] = TSha_fixed[i];
    end for;
  end if;
  for i in 1:nPorts loop
    yFixed[kFluIntT_outflow + i] = T_outflow_fixed[i];
    for j in 1:Medium.nXi loop
      yFixed[kFluIntXi_outflow + (i - 1)*Medium.nXi + j] = Xi_outflow_fixed[(i
         - 1)*Medium.nXi + j];
    end for;
    for j in 1:Medium.nC loop
      yFixed[kFluIntC_outflow + (i - 1)*Medium.nC + j] = C_outflow_fixed[(i - 1)
        *Medium.nC + j];
    end for;
  end for;
  for i in 1:nSen loop
    yFixed[kSen + i] = 0;
  end for;
equation
  //////////////////////////////////////////////////////////////////////
  // Data exchange with CFD block
  if haveConExt then
    for i in 1:nConExt loop
      if datConExt[i].boundaryCondition == Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature then
        connect(cfd.u[kConExt + i], cfdConExt[i].T_out) annotation (Line(
            points={{-42,190},{-60,190},{-60,224},{179,224}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(cfd.y[kConExt + i], cfdConExt[i].Q_flow_in) annotation (Line(
            points={{-19,190},{60,190},{60,228},{178,228}},
            color={0,0,127},
            smooth=Smooth.None));
      else
        connect(cfd.u[kConExt + i], cfdConExt[i].Q_flow_out) annotation (Line(
            points={{-42,190},{-60,190},{-60,216},{179,216}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(cfd.y[kConExt + i], cfdConExt[i].T_in) annotation (Line(
            points={{-19,190},{60,190},{60,212},{179,212}},
            color={0,0,127},
            smooth=Smooth.None));
      end if;
    end for;
  end if;

  if haveConExtWin then
    for i in 1:nConExtWin loop
      if datConExtWin[i].boundaryCondition == Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature then
        connect(cfd.u[kConExtWin + i], cfdConExtWin[i].T_out) annotation (Line(
            points={{-42,190},{-60,190},{-60,172},{60,172},{60,184},{179,184}},
            color={0,0,127},
            smooth=Smooth.None));

        connect(cfd.y[kConExtWin + i], cfdConExtWin[i].Q_flow_in) annotation (
            Line(
            points={{-19,190},{60,190},{60,188},{178,188}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(cfd.u[kGlaUns + i], cfdGlaUns[i].T_out) annotation (Line(
            points={{-42,190},{-60,190},{-60,124},{179,124}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(cfd.y[kGlaUns + i], cfdGlaUns[i].Q_flow_in) annotation (Line(
            points={{-19,190},{60,190},{60,128},{178,128}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(cfd.u[kConExtWinFra + i], cfdConExtWinFra[i].T_out) annotation (
           Line(
            points={{-42,190},{-60,190},{-60,4},{179,4}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(cfd.y[kConExtWinFra + i], cfdConExtWinFra[i].Q_flow_in)
          annotation (Line(
            points={{-19,190},{60,190},{60,8},{178,8}},
            color={0,0,127},
            smooth=Smooth.None));
      else
        connect(cfd.u[kConExtWin + i], cfdConExtWin[i].Q_flow_out) annotation (
            Line(
            points={{-42,190},{-60,190},{-60,176},{179,176}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(cfd.y[kConExtWin + i], cfdConExtWin[i].T_in) annotation (Line(
            points={{-19,190},{60,190},{60,172},{179,172}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(cfd.u[kGlaUns + i], cfdGlaUns[i].Q_flow_out) annotation (Line(
            points={{-42,190},{-60,190},{-60,116},{179,116}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(cfd.y[kGlaUns + i], cfdGlaUns[i].T_in) annotation (Line(
            points={{-19,190},{60,190},{60,112},{179,112}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(cfd.u[kConExtWinFra + i], cfdConExtWinFra[i].Q_flow_out)
          annotation (Line(
            points={{-42,190},{-60,190},{-60,-4},{179,-4}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(cfd.y[kConExtWinFra + i], cfdConExtWinFra[i].T_in) annotation (
            Line(
            points={{-19,190},{60,190},{60,-8},{179,-8}},
            color={0,0,127},
            smooth=Smooth.None));
      end if;
    end for;
  end if;

  if haveShade then
    for i in 1:nConExtWin loop
      if datConExtWin[i].boundaryCondition == Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature then
        connect(cfd.u[kGlaSha + i], cfdGlaSha[i].T_out) annotation (Line(
            points={{-42,190},{-60,190},{-60,84},{179,84}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(cfd.y[kGlaSha + i], cfdGlaSha[i].Q_flow_in) annotation (Line(
            points={{-19,190},{60,190},{60,88},{178,88}},
            color={0,0,127},
            smooth=Smooth.None));
      else
        connect(cfd.u[kGlaSha + i], cfdGlaSha[i].Q_flow_out) annotation (Line(
            points={{-42,190},{-60,190},{-60,76},{179,76}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(cfd.y[kGlaSha + i], cfdGlaSha[i].T_in) annotation (Line(
            points={{-19,190},{60,190},{60,72},{179,72}},
            color={0,0,127},
            smooth=Smooth.None));
      end if;
    end for;
  end if;

  if haveConPar then
    for i in 1:nConPar loop
      if datConPar[i].boundaryCondition == Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature then
        connect(cfd.u[kConPar_a + i], cfdConPar_a[i].T_out) annotation (Line(
            points={{-42,190},{-60,190},{-60,-56},{179,-56}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(cfd.y[kConPar_a + i], cfdConPar_a[i].Q_flow_in) annotation (
            Line(
            points={{-19,190},{60,190},{60,-52},{178,-52}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(cfd.u[kConPar_b + i], cfdConPar_b[i].T_out) annotation (Line(
            points={{-42,190},{-60,190},{-60,-96},{179,-96}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(cfd.y[kConPar_b + i], cfdConPar_b[i].Q_flow_in) annotation (
            Line(
            points={{-19,190},{60,190},{60,-92},{178,-92}},
            color={0,0,127},
            smooth=Smooth.None));
      else
        connect(cfd.u[kConPar_a + i], cfdConPar_a[i].Q_flow_out) annotation (
            Line(
            points={{-42,190},{-60,190},{-60,-64},{179,-64}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(cfd.y[kConPar_a + i], cfdConPar_a[i].T_in) annotation (Line(
            points={{-19,190},{60,190},{60,-68},{179,-68}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(cfd.u[kConPar_b + i], cfdConPar_b[i].Q_flow_out) annotation (
            Line(
            points={{-42,190},{-60,190},{-60,-104},{179,-104}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(cfd.y[kConPar_b + i], cfdConPar_b[i].T_in) annotation (Line(
            points={{-19,190},{60,190},{60,-108},{179,-108}},
            color={0,0,127},
            smooth=Smooth.None));
      end if;
    end for;
  end if;

  if haveConBou then
    for i in 1:nConBou loop
      if datConBou[i].boundaryCondition == Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature then
        connect(cfd.u[kConBou + i], cfdConBou[i].T_out) annotation (Line(
            points={{-42,190},{-60,190},{-60,-156},{179,-156}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(cfd.y[kConBou + i], cfdConBou[i].Q_flow_in) annotation (Line(
            points={{-19,190},{60,190},{60,-152},{178,-152}},
            color={0,0,127},
            smooth=Smooth.None));
      else
        connect(cfd.u[kConBou + i], cfdConBou[i].Q_flow_out) annotation (Line(
            points={{-42,190},{-60,190},{-60,-164},{179,-164}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(cfd.y[kConBou + i], cfdConBou[i].T_in) annotation (Line(
            points={{-19,190},{60,190},{60,-168},{179,-168}},
            color={0,0,127},
            smooth=Smooth.None));
      end if;
    end for;
  end if;

  if haveSurBou then
    for i in 1:nSurBou loop
      if surBou[i].boundaryCondition == Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature then
        connect(cfd.u[kSurBou + i], cfdSurBou[i].T_out) annotation (Line(
            points={{-42,190},{-60,190},{-60,-216},{179,-216}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(cfd.y[kSurBou + i], cfdSurBou[i].Q_flow_in) annotation (Line(
            points={{-19,190},{60,190},{60,-212},{178,-212}},
            color={0,0,127},
            smooth=Smooth.None));
      else
        connect(cfd.u[kSurBou + i], cfdSurBou[i].Q_flow_out) annotation (Line(
            points={{-42,190},{-60,190},{-60,-224},{179,-224}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(cfd.y[kSurBou + i], cfdSurBou[i].T_in) annotation (Line(
            points={{-19,190},{60,190},{60,-228},{179,-228}},
            color={0,0,127},
            smooth=Smooth.None));
      end if;
    end for;
  end if;

  connect(cfdConExt.port, conExt) annotation (Line(
      points={{200,220},{240,220}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(cfdConExtWin.port, conExtWin) annotation (Line(
      points={{200,180},{240,180}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(cfdGlaUns.port, glaUns) annotation (Line(
      points={{200,120},{220,120},{220,120},{240,120}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(cfdGlaSha.port, glaSha) annotation (Line(
      points={{200,80},{240,80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(cfdConExtWinFra.port, conExtWinFra) annotation (Line(
      points={{200,0},{242,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(cfdConPar_a.port, conPar_a) annotation (Line(
      points={{200,-60},{242,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(cfdConPar_b.port, conPar_b) annotation (Line(
      points={{200,-100},{242,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(cfdConBou.port, conBou) annotation (Line(
      points={{200,-160},{222,-160},{222,-160},{242,-160}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(cfdSurBou.port, conSurBou) annotation (Line(
      points={{200,-220},{241,-220}},
      color={191,0,0},
      smooth=Smooth.None));
  // Connections to heat port of air volume
  connect(cfd.y[kHeaPorAir + 1], cfdHeaPorAir.T) annotation (Line(
      points={{-19,190},{60,190},{60,8.88178e-16},{-138,8.88178e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  // Connections to shade
  if haveShade then
    for i in 1:nConExtWin loop
      connect(cfd.u[kUSha + i], uSha[i]) annotation (Line(
          points={{-42,190},{-60,190},{-60,200},{-260,200}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(cfd.u[kQRadAbs_flow + i], QRadAbs_flow[i]) annotation (Line(
          points={{-42,190},{-60,190},{-60,90},{-260,90}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(cfd.y[kTSha + i], TSha[i]) annotation (Line(
          points={{-19,190},{60,190},{60,60},{-250,60}},
          color={0,0,127},
          smooth=Smooth.None));
    end for;
  end if;

  // Connection for heat gain that is added to the room
  // (averaged over the whole room air volume)
  connect(QTotCon_flow_W.y, cfd.u[kQConGai_flow + 1]) annotation (Line(
      points={{-119,-50},{-60,-50},{-60,190},{-42,190}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QLat_flow, cfd.u[kQLatGai_flow + 1]) annotation (Line(
      points={{-260,-160},{-190,-160},{-190,-72},{-60,-72},{-60,190},{-42,190}},
      color={0,0,127},
      smooth=Smooth.None));

  // Connections to fluid port
  connect(ports, fluInt.ports) annotation (Line(
      points={{0,-238},{0,-198}},
      color={0,127,255},
      smooth=Smooth.None));

  // Output signals from fluInt block

  // The pressure of the air volume will be sent from Modelica to CFD
  connect(cfd.u[kFluIntP + 1], fluInt.p) annotation (Line(
      points={{-42,190},{-60,190},{-60,-180},{-11,-180}},
      color={0,0,127},
      smooth=Smooth.None));
  for i in 1:nPorts loop
    connect(cfd.u[kFluIntM_flow + i], fluInt.m_flow[i]) annotation (Line(
        points={{-42,190},{-60,190},{-60,-184},{-11,-184}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(cfd.u[kFluIntT_inflow + i], fluInt.T_inflow[i]) annotation (Line(
        points={{-42,190},{-60,190},{-60,-188},{-11,-188}},
        color={0,0,127},
        smooth=Smooth.None));
    for j in 1:Medium.nXi loop
      connect(cfd.u[kFluIntXi_inflow + (i - 1)*Medium.nXi + j], fluInt.Xi_inflow[
        (i - 1)*Medium.nXi + j]) annotation (Line(
          points={{-42,190},{-60,190},{-60,-192},{-11,-192}},
          color={0,0,127},
          smooth=Smooth.None));
    end for;
    for j in 1:Medium.nC loop
      connect(cfd.u[kFluIntC_inflow + (i - 1)*Medium.nC + j], fluInt.C_inflow[(
        i - 1)*Medium.nC + j]) annotation (Line(
          points={{-42,190},{-60,190},{-60,-196},{-11,-196}},
          color={0,0,127},
          smooth=Smooth.None));
    end for;
  end for;
  // Input signals to fluInt block
  // The pressures of ports[2:nPorts] will be sent from CFD to Modelica
  for i in 1:nPorts loop
    connect(cfd.y[kFluIntT_outflow + i], fluInt.T_outflow[i]) annotation (Line(
        points={{-19,190},{60,190},{60,-188},{12,-188}},
        color={0,0,127},
        smooth=Smooth.None));
    for j in 1:Medium.nXi loop
      connect(cfd.y[kFluIntXi_outflow + (i - 1)*Medium.nXi + j], fluInt.Xi_outflow[
        (i - 1)*Medium.nXi + j]) annotation (Line(
          points={{-19,190},{60,190},{60,-192},{12,-192}},
          color={0,0,127},
          smooth=Smooth.None));
    end for;
    for j in 1:Medium.nC loop
      connect(cfd.y[kFluIntC_outflow + (i - 1)*Medium.nC + j], fluInt.C_outflow[
        (i - 1)*Medium.nC + j]) annotation (Line(
          points={{-19,190},{60,190},{60,-196},{12,-196}},
          color={0,0,127},
          smooth=Smooth.None));
    end for;
  end for;

  // Connections for sensor signal
  if haveSensor then
    for i in 1:nSen loop
      connect(cfd.y[kSen + i], yCFD[i]) annotation (Line(
          points={{-19,190},{60,190},{60,-234},{180,-234},{180,-250}},
          color={0,0,127},
          smooth=Smooth.None));
    end for;
  end if;

  connect(heaPorAir, senHeaFlo.port_a) annotation (Line(
      points={{-240,0},{-210,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(senHeaFlo.port_b, cfdHeaPorAir.port) annotation (Line(
      points={{-190,0},{-160,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(senHeaFlo.Q_flow, QTotCon_flow.u1) annotation (Line(
      points={{-200,-10},{-200,-44},{-182,-44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QCon_flow, QTotCon_flow.u2) annotation (Line(
      points={{-260,-100},{-200,-100},{-200,-56},{-182,-56}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(QTotCon_flow.y, QTotCon_flow_W.u) annotation (Line(
      points={{-159,-50},{-142,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    preferredView="info",
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-240,-240},{240,
            240}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-240,-240},{240,
            240}}), graphics={Rectangle(
          extent={{-144,184},{148,-200}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={170,213,255},
          fillPattern=FillPattern.Sphere)}),
    Documentation(info="<html>
<p>
This model computes the heat and mass balance of the air using Computational Fluid Dynamics program.
</p>
<p>
For a documentation of the exchange parameters and variables, see
<a href=\"modelica://Buildings.ThermalZones.Detailed.UsersGuide.CFD\">
Buildings.ThermalZones.Detailed.UsersGuide.CFD</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 17, 2016, by Michael Wetter:<br/>
Removed protected parameter <code>uStart</code>, which is not needed.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/579\">issue 579</a>.
</li>
<li>
December 31, 2013, by Wangda Zuo:<br/>
<ul>
<li>
Corrected the connections. cfd.u should always be connected to Q_flow_out and cfd.y to T_in.
</li>
<li>
Added unit [W] for total convective sensible heat before it is input into component cfd.
</li>
<li>
Enabled transfer of C and X information.
</li>
<li>
Added initial value of shade.
</li>
</ul>
</li>
<li>
July 17, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end CFDAirHeatMassBalance;
