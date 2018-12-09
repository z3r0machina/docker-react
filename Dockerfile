###############################################################################
# BUILD PHASE                                                                 #
###############################################################################

FROM node:alpine as builder

WORKDIR /app

COPY package.json .
RUN npm install

# Want to copy all of the source code now since source code won't be changed in
# production.
COPY . .

RUN ["npm", "run", "build"]


###############################################################################
# RUNTIME PHASE                                                               #
###############################################################################

FROM nginx

# Copy over /app/build directory from the builder phase.
COPY --from=builder /app/build /usr/share/nginx/html

# The default command from nginx will automatically start nginx up.
