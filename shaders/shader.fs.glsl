precision mediump float;

uniform highp vec3 uLightPosition;
uniform highp vec3 uAmbientLightColor;
uniform highp vec3 uDiffuseLightColor;
uniform highp vec3 uSpecularLightColor;

uniform highp float uLinearAttenuation;
uniform highp float uQuadraticAttenuation;
uniform highp float uIntensivity;
uniform float uColorWeight;
uniform float uDigitWeight;
uniform float uMaterialWeight;

uniform sampler2D uSampler;
uniform sampler2D uNormalSampler;

varying vec3 vNormal;
varying vec3 vTangent;
varying vec3 vBitangent;

varying vec3 vFragPos;
varying vec3 vLightPos;
// varying vec3 vLightColor;
// varying vec3 vFragColor;

varying highp vec2 vTextureCoord;

const float shininess = 16.0;

vec3 light(vec3 lightDir, vec3 normal) {
    float distance = length(lightDir);
    float attenuation = 1.0 / (1.0 + uLinearAttenuation * distance + uQuadraticAttenuation * distance * distance);

    float diff = max(dot(normal, lightDir), 0.0);
    vec3 diffuse = uDiffuseLightColor * diff * attenuation * uIntensivity;

    vec3 viewDir = normalize(-vFragPos);
    vec3 reflectDir = reflect(-lightDir, normal);

    float spec = pow(max(dot(viewDir, reflectDir), 0.0), shininess);
    vec3 specular = uSpecularLightColor * spec * attenuation * uIntensivity;

    return uAmbientLightColor + diffuse + specular;
}

void main(void) {
    vec4 textureColor = texture2D(uSampler, vTextureCoord);

    vec3 normalMapValue = texture2D(uNormalSampler, vTextureCoord).rgb;
    normalMapValue = normalize(normalMapValue * 2.0 - 1.0); // Correct normalization

    vec3 viewDir = normalize(-vFragPos);
    vec3 lightDir = normalize(vLightPos - vFragPos); // Use world space light direction
    vec3 vLightWeighting = light(lightDir, normalize(vNormal)); // Pass world space normal for lighting

    gl_FragColor = vec4(textureColor.rgb * vLightWeighting, 1.0);
}