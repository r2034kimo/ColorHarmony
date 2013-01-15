//
//  Shader.fsh
//  ColorHarmonization
//
//  Created by Johnny Bee on 13/1/11.
//  Copyright (c) 2013年 Johnny. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
