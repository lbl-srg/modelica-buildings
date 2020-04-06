within Buildings.ThermalZones.Detailed.Examples.SingleZoneFloor.BaseClasses;
model Floor_IntGai "Floor with modified internal gains"
  extends Buildings.Examples.VAVReheat.ThermalZones.Floor(gai(K=10*[0.4; 0.4;
          0.2]));
end Floor_IntGai;
