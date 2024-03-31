attribute vec4 aVertexPosition;
attribute vec3 aVertexNormal;
// attribute vec3 aVertexColor;

uniform mat4 uModelViewMatrix;
uniform mat4 uProjectionMatrix;
uniform vec3 uLightPosition;
uniform vec3 uDiffuseLightColor;
uniform vec3 uSpecularLightColor;
uniform vec3 uAmbientLightColor;

uniform float uLightingMode;

varying vec3 vNormal;
varying vec3 vFragPos;
varying vec3 vLightColor;

const float shininess = 16.0;

vec3 light(vec3 lightDir, vec3 normal) {
    float diff = max(dot(normal, lightDir), 0.0);
    vec3 diffuse = uDiffuseLightColor * diff;

    vec3 viewDir = -normalize(vFragPos);
    vec3 reflectDir = reflect(-lightDir, normal);

    float spec = pow(max(dot(viewDir, reflectDir), 0.0), shininess);
    vec3 specular = uSpecularLightColor * spec;

    return (uAmbientLightColor + diffuse + specular);
}

vec3 lambertLight(vec3 lightDir, vec3 normal) {
    float diff = max(dot(normal, lightDir), 0.0);
    return uAmbientLightColor + uDiffuseLightColor * diff;
}

void main(void) {
    vFragPos = (uModelViewMatrix * aVertexPosition).xyz;

    vNormal = (uModelViewMatrix * vec4(aVertexNormal, 0.0)).xyz;

    vec3 lightDir = normalize(uLightPosition - vFragPos);

    if(uLightingMode < 0.0)
        vLightColor = light(lightDir, vNormal);
    else
        vLightColor = lambertLight(lightDir, vNormal);

    gl_Position = uProjectionMatrix * vec4(vFragPos, 1.0);
}