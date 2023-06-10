

Func_TubeConnector(tubecolor, modelid, Float:X, Float:Y, Float:Z, Float:RX, Float:RY, Float:RZ)
{
    new tube = CreateDynamicObject(modelid, X, Y, Z, RX, RY, RZ, 1000, 0);
    switch(tubecolor)
    {
        case 0: SetDynamicObjectMaterial(tube, 0, 19659, "MatTubes", "RedDirt1");
        case 1: SetDynamicObjectMaterial(tube, 0, 19659, "MatTubes", "GreenDirt1");
        case 2: SetDynamicObjectMaterial(tube, 0, 19659, "MatTubes", "BlueDirt1");
        case 3: SetDynamicObjectMaterial(tube, 0, 19659, "MatTubes", "YellowDirt1");
        case 4: SetDynamicObjectMaterial(tube, 0, 19659, "MatTubes", "PurpleDirt1");
    }
    return tube;
}