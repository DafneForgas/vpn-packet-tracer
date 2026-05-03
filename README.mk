# Proyecto VPN Site-to-Site con Cisco Packet Tracer

## Descripción del proyecto

Este proyecto implementa una **red VPN site-to-site** utilizando Cisco Packet Tracer, permitiendo la comunicación segura entre tres redes distintas:

- **Cádiz** → 192.168.10.0/24  
- **Barcelona** → 192.168.20.0/24  
- **Asturias** → 192.168.30.0/24  

Se han configurado túneles VPN IPsec entre:

- Cádiz ↔ Barcelona  
- Cádiz ↔ Asturias  

---

## Objetivo

El objetivo principal es permitir la **comunicación segura entre sedes** mediante el uso de cifrado IPsec en routers Cisco, simulando un entorno empresarial real.

---

## Topología de red

### Redes LAN
- Cádiz: 192.168.10.0/24  
- Barcelona: 192.168.20.0/24  
- Asturias: 192.168.30.0/24  

### Redes WAN
- Cádiz ↔ Barcelona: 15.0.0.0/8  
- Cádiz ↔ Asturias: 16.0.0.0/8  

---

## Configuración de la VPN

### Fase 1 – ISAKMP

Configuración de la negociación de claves:

```bash
crypto isakmp policy 10
 encr aes 256
 authentication pre-share
 hash sha
 group 2
 lifetime 86400


### Claves precompartidas
crypto isakmp key v1_policy10 address 15.0.0.2  
crypto isakmp key v1_policy20 address 16.0.0.2  

---

### Fase 2 (IPsec)
crypto ipsec transform-set v2_policy10 esp-aes esp-sha-hmac  
crypto ipsec transform-set v2_policy20 esp-aes esp-sha-hmac  

---

### ACL (tráfico interesante)
access-list 101 permit ip 192.168.10.0 0.0.0.255 192.168.20.0 0.0.0.255  
access-list 102 permit ip 192.168.10.0 0.0.0.255 192.168.30.0 0.0.0.255  

---

### Crypto Maps
crypto map v3_policy10 10 ipsec-isakmp  
 set peer 15.0.0.2  
 set transform-set v2_policy10  
 match address 101  

crypto map v3_policy20 20 ipsec-isakmp  
 set peer 16.0.0.2  
 set transform-set v2_policy20  
 match address 102  

---

### Aplicación a interfaces
interface Serial0/3/0  
 crypto map v3_policy10  

interface Serial0/3/1  
 crypto map v3_policy20  

---

## Pruebas realizadas
- Comunicación entre redes mediante ping  
- Establecimiento de túneles VPN IPsec  
- Validación de cifrado entre sedes  

---

## Capturas

### Topología de red
![Topología](imagenes/topologia.png)

### Prueba de conectividad (ping)
![Ping VPN](imagenes/ping_vpn.png)

### Estado ISAKMP
![ISAKMP](imagenes/isakmp.png)

### Estado IPsec
![IPsec](imagenes/ipsec.png)

---

## Observaciones
- El primer ping puede fallar debido al establecimiento del túnel VPN.  
- La conexión se estabiliza tras la negociación ISAKMP.  
- Es necesario que las ACL coincidan con las redes configuradas en cada extremo.  

---

## Conclusión
Se ha implementado correctamente una red VPN site-to-site con IPsec, permitiendo la comunicación segura entre distintas sedes mediante cifrado de tráfico.
