within Buildings.Fluid.Storage.PCM.BaseClasses;
model partialUnitCellPhaseChangeTwoCircuit

    replaceable parameter Buildings.Fluid.Storage.PCM.Data.HeatExchanger.Generic Design "Design of HX";
  replaceable parameter Buildings.Fluid.Storage.PCM.Data.PhaseChangeMaterial.Generic Material "Phase Change Material";
  parameter Modelica.Units.SI.Temperature TStart_pcm "Starting temperature of pcm" annotation(Dialog(tab="General", group="Initialization"));

/////////////////////////////////////////////

  replaceable parameter
    Buildings.HeatTransfer.Data.SolidsPCM.Generic PCM(x=sfin, d=Material.d, c=Material.c, k=Material.k, LHea=Material.LHea, TSol=Material.TSol, TLiq=Material.TLiq) "Storage material record" annotation(Dialog(group="PCM"));
  parameter Modelica.Units.SI.Energy TesNominal = PCM.LHea*PCM.d*PCM.x*A_pcm "Nominal Capacity (factor * 1kWh)" annotation(Dialog(group="Sizing"));
  parameter Modelica.Units.SI.DimensionlessRatio TesScale = Design.TesDesign/TesNominal "Scale factor for PCM HX size" annotation(Dialog(group="Sizing"));
  parameter Modelica.Units.SI.Length H = TesScale*Design.coeff_H "Height of finned tube heat exchanger"
                                                                                                       annotation(Dialog(group="Heat Exchanger"));

  parameter Integer Ntubes = Design.Ntubebanks*Design.Ntubes_bank "Number of tubes in heat exchanger"
                                                                                                     annotation(Dialog(group="Tubes"));
  parameter Integer NPro = integer(Ntubes*Design.NPro_coeff) "Number of process water tubes in heat exchanger"
                                                                                                              annotation(Dialog(group="Tubes"));
  parameter Integer NDom = integer(Ntubes*Design.NDom_coeff) "Number of domestic water tubes in heat exchanger"
                                                                                                               annotation(Dialog(group="Tubes"));
  parameter Modelica.Units.SI.Area A_tubeDom = Design.di*Modelica.Constants.pi*NDom*Design.D "Area of tubes in domestic circuit"
                                                                                                                                annotation(Dialog(group="Tubes"));
  parameter Modelica.Units.SI.Area A_tubePro = Design.di*Modelica.Constants.pi*NPro*Design.D "Area of tubes in process circuit"
                                                                                                                               annotation(Dialog(group="Tubes"));

  parameter Integer Nfins = integer(Design.Nfins_meter*Design.D) "Number of fins in heat exchanger"
                                                                                                   annotation(Dialog(group="Fins"));
  parameter Modelica.Units.SI.Length tfins = Design.t_fin*Nfins "Total thickness of all fins"
                                                                                             annotation(Dialog(group="Fins"));
  parameter Modelica.Units.SI.Length sfin = 1/Design.Nfins_meter - Design.t_fin "Spacing between fins"
                                                                                                      annotation(Dialog(group="Fins"));
  parameter Modelica.Units.SI.Length xfin = ((H*Design.W)/(Design.di*Modelica.Constants.pi*Ntubes)) "Fin heat transfer area per unit length"
                                                                                                                                            annotation(Dialog(group="Fins"));
  parameter Modelica.Units.SI.Area A_fin = Design.do*Modelica.Constants.pi*Ntubes*tfins "Area of fins"
                                                                                                      annotation(Dialog(group="Fins"));

  parameter Modelica.Units.SI.Area A_pcm=(Nfins*2*Design.W*H - Modelica.Constants.pi*(Design.do/2)^2*Ntubes) + Design.do*Modelica.Constants.pi*Ntubes*(Design.D-tfins) "Area of pcm" annotation(Dialog(group="PCM"));


  replaceable parameter
    Buildings.HeatTransfer.Data.Solids.Generic Aluminum(x=Design.t_fin, k=235, c=904, d=2700) "Aluminum fin material record"
                                                                                                                            annotation(Dialog(group="Materials"));
  replaceable parameter
    Buildings.HeatTransfer.Data.Solids.Generic Copper(x=(Design.do - Design.di), k=400, c=384, d=8960) "Copper tube material record"
                                                                                                                                    annotation(Dialog(group="Materials"));

/////////////////////////////////////////////



  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a tubHeaPort_b2 annotation (Placement(transformation(extent={{-110,-48},{-90,-28}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b tubHeaPort_a2 annotation (Placement(transformation(extent={{90,-48},{110,-28}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a tubHeaPort_a1 annotation (Placement(transformation(extent={{-110,28},{-90,48}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b tubHeaPort_b1 annotation (Placement(transformation(extent={{90,28},{110,48}})));
  Buildings.HeatTransfer.Conduction.SingleLayer tubeDom(
    stateAtSurface_b=false,
    T_a_start=TStart_pcm,
    T_b_start=TStart_pcm,
    material=Copper,
    A=A_tubeDom) "Copper tubes in domestic circuit for discharge"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,48})));
  Buildings.HeatTransfer.Conduction.SingleLayer tubePro(
    stateAtSurface_b=false,
    T_a_start=TStart_pcm,
    T_b_start=TStart_pcm,
    material=Copper,
    A=A_tubePro) "Copper tubes in process circuit for charge"   annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,-48})));
  Buildings.HeatTransfer.Conduction.SingleLayer finsDom(
    stateAtSurface_b=false,
    T_a_start=TStart_pcm,
    T_b_start=TStart_pcm,
    material=Aluminum,
    A=A_fin) "Aluminum fins between domestic circuit and PCM" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,24})));
  Buildings.HeatTransfer.Conduction.SingleLayer finsPro(
    stateAtSurface_b=false,
    T_a_start=TStart_pcm,
    T_b_start=TStart_pcm,
    material=Aluminum,
    A=A_fin) "Aluminum fins between process circuit and PCM" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,-24})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloDom
    annotation (Placement(transformation(extent={{-58,20},{-70,8}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloPro
    annotation (Placement(transformation(extent={{-70,-16},{-58,-4}})));
equation
  connect(tubeDom.port_a,finsDom. port_b)
    annotation (Line(points={{-40,38},{-40,34}}, color={191,0,0}));
  connect(finsPro.port_b,tubePro. port_a)
    annotation (Line(points={{-40,-34},{-40,-38}}, color={191,0,0}));
  connect(tubeDom.port_a, tubHeaPort_a1)
    annotation (Line(points={{-40,38},{-100,38}}, color={191,0,0}));
  connect(tubeDom.port_a, tubHeaPort_b1)
    annotation (Line(points={{-40,38},{100,38}}, color={191,0,0}));
  connect(tubePro.port_a, tubHeaPort_b2)
    annotation (Line(points={{-40,-38},{-100,-38}}, color={191,0,0}));
  connect(tubePro.port_a, tubHeaPort_a2)
    annotation (Line(points={{-40,-38},{100,-38}}, color={191,0,0}));
  connect(heaFloPro.port_a,finsPro. port_a)
    annotation (Line(points={{-70,-10},{-70,-14},{-40,-14}}, color={191,0,0}));
  connect(heaFloDom.port_a,finsDom. port_a)
    annotation (Line(points={{-58,14},{-40,14}}, color={191,0,0}));
  annotation (Icon(graphics={
          Rectangle(
          extent={{-70,60},{70,-66}},
          lineColor={0,0,0},
          fillColor={244,125,35},
          fillPattern=FillPattern.CrossDiag)}));
end partialUnitCellPhaseChangeTwoCircuit;
